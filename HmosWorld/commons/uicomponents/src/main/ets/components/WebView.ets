/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ColumnEnum, CommonConstants, Logger, OffsetEnum, SpanEnum, WebpageStatus } from '@ohos/utils';
import { FailureLayout } from './FailureLayout';
import { LoadingLayout } from './LoadingLayout';

const TAG = '[WebView]';

@Component
export struct WebView {
  handlePageEnd?: () => void;
  url: ResourceStr = '';
  isLarge?: boolean = true;
  @Link webViewController: WebviewController;
  @State webStatus: WebpageStatus = WebpageStatus.INIT;

  build() {
    GridRow({
      columns: this.isLarge ? { sm: ColumnEnum.SM, md: ColumnEnum.MD, lg: ColumnEnum.LG } : 1,
      gutter: {
        x: {
          sm: $r('app.float.xxl_padding_margin'),
          md: $r('app.float.md_padding_margin'),
          lg: $r('app.float.md_padding_margin')
        }
      },
      breakpoints: { reference: BreakpointsReference.ComponentSize }
    }) {
      GridCol({
        span: this.isLarge ? { sm: SpanEnum.SM, md: SpanEnum.MD, lg: SpanEnum.LG } : 1,
        offset: this.isLarge ? { sm: OffsetEnum.SM, md: OffsetEnum.MD, lg: OffsetEnum.LG } : 0
      }) {
        Stack() {
          Web({ controller: this.webViewController, src: this.url })
            .darkMode(WebDarkMode.Auto)
            .domStorageAccess(true)
            .zoomAccess(true)
            .fileAccess(true)
            .mixedMode(MixedMode.All)
            .cacheMode(CacheMode.None)
            .javaScriptAccess(true)
            .width(CommonConstants.FULL_PERCENT)
            .onProgressChange((event) => {
              Logger.info(TAG, 'newProgress:' + event?.newProgress);
            })
            .onPageBegin(() => {
              Logger.info(TAG, 'start loading');
            })
            .onErrorReceive(() => {
              this.webStatus = WebpageStatus.FINISHED
            })
            .onPageEnd(() => {
              Logger.info(TAG, 'loading completed');
              if (this.webStatus != WebpageStatus.ERROR) {
                this.webStatus = WebpageStatus.FINISHED;
                this.handlePageEnd && this.handlePageEnd();
              }
            })

          if (this.webStatus === WebpageStatus.INIT) {
            Column() {
              LoadingLayout()
            }
            .backgroundColor(Color.White)
          }

          if (this.webStatus === WebpageStatus.ERROR) {
            Column() {
              FailureLayout({ handleReload: () => {
                this.webViewController.refresh();
                this.webStatus = WebpageStatus.INIT;
              } })
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color.White)
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.FULL_PERCENT)
          }
        }
      }
    }
    .layoutWeight(1)
  }
}
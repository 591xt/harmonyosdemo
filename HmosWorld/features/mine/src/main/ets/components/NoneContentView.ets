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

import { CommonConstants } from '@ohos/utils';

@Component
export struct NoneContentView {
  imgSrc: Resource = $r('app.media.ic_browse_no');
  description: Resource = $r('app.string.to_view');

  build() {
    Row() {
      Column() {
        Row() {
          Image(this.imgSrc)
            .size({ width: $r('app.float.none_view_image_size'), height: $r('app.float.none_view_image_size') })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: $r('app.float.none_view_image_padding') })
        .width(CommonConstants.FULL_PERCENT)

        Text(this.description)
          .fontColor($r('app.color.hmos_medium_black'))
          .fontSize($r('app.float.title_font_size'))
          .padding({ top: $r('app.float.sm_padding_margin') })
      }
      .height(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
  }
}
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

import webview from '@ohos.web.webview';
import common from '@ohos.app.ability.common';
import { EventTypeEnum, LearningResource, UserModel } from '@ohos/mine';
import { InteractiveAreaView, TopNavigationView, WebView } from '@ohos/uicomponents';
import { CommonConstants, ObservedArray, ResourcesType } from '@ohos/utils';

const eventHub: common.EventHub = (getContext(this) as common.UIAbilityContext).eventHub;

@Component
export struct ArticleDetailView {
  onDestinationBack: () => boolean = () => false;
  @Prop articleDetail: LearningResource = new LearningResource();
  @Link webViewController: WebviewController;
  @State userModel: UserModel = UserModel.getInstance();
  @State collectedIds: ObservedArray<string> = this.userModel.collectedIds;
  @State likedIds: ObservedArray<string> = this.userModel.likedIds;
  @State showInteractiveArea: boolean = true;

  aboutToAppear() {
    this.webViewController = new webview.WebviewController();
  }

  isCollected(): boolean {
    return this.collectedIds.some((id: string) => id === this.articleDetail.id);
  }

  isLiked(): boolean {
    return this.likedIds.some((id: string) => id === this.articleDetail.id);
  }

  build() {
    NavDestination() {
      Column() {
        TopNavigationView({
          title: this.articleDetail.type === ResourcesType.FEED ? $r('app.string.feed') : $r('app.string.article'),
          onBackClick: this.onDestinationBack
        })
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            WebView({
              url: this.articleDetail.webUrl,
              webViewController: $webViewController,
              handlePageEnd: () => {
                if (this.webViewController.accessBackward()) {
                  this.showInteractiveArea = false;
                } else {
                  this.showInteractiveArea = true;
                }
              }
            })
          }
          .padding({
            left: $r('app.float.md_padding_margin'),
            right: $r('app.float.md_padding_margin')
          })

          if (this.showInteractiveArea) {
            InteractiveAreaView({
              isLiked: this.isLiked(),
              isCollected: this.isCollected(),
              onCollected: () => {
                eventHub.emit(EventTypeEnum.COLLECTED, {
                  resourceId: this.articleDetail.id,
                  resourceType: this.articleDetail.type,
                  actionValue: !this.isCollected()
                })
              },
              onLiked: () => {
                eventHub.emit(EventTypeEnum.LIKED, {
                  resourceId: this.articleDetail.id,
                  resourceType: this.articleDetail.type,
                  actionValue: !this.isLiked()
                })
              }
            })
              .margin({ bottom: $r('app.float.top_navigation_height') })
          }
        }
      }
      .padding({ top: AppStorage.get<number>('statusBarHeight') })
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .onBackPressed(() => this.onDestinationBack())
  }
}
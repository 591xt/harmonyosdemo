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

import { LearningResource } from '@ohos/mine';
import { LoadingMoreLayout, NoMoreLayout, TopNavigationView } from '@ohos/uicomponents';
import { BreakpointType, BreakpointTypeEnum, CommonConstants, LoadingStatus, ObservedArray } from '@ohos/utils';
import { DiscoverModel } from '../model/DiscoverModel';
import { FeedCardView } from './feed/FeedCardView';

const LOAD_MORE_MIN_DRAG_DISTANCE = 60;

@Component
export struct FeedList {
  onDestinationBack: () => void = () => {
  };
  @State webViewController?: WebviewController = undefined;

  build() {
    NavDestination() {
      Column() {
        TopNavigationView({
          title: $r('app.string.hot_feeds'),
          onBackClick: () => this.onDestinationBack()
        })
        HotFeeds()
      }
      .padding({
        top: AppStorage.get<number>('statusBarHeight'),
      })
      .justifyContent(FlexAlign.Center)
      .constraintSize({ minHeight: CommonConstants.FULL_PERCENT })
      .backgroundColor($r('app.color.page_background_color'))
      .width(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .hideTitleBar(true)
    .onBackPressed(() => {
      this.onDestinationBack();
      return true;
    })
  }
}

@Component
struct HotFeeds {
  @State discoverModel: DiscoverModel = DiscoverModel.getInstance();
  @State hotFeedList: ObservedArray<LearningResource> = this.discoverModel.hotFeedList;
  @State isListReachEnd: boolean = false;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;

  build() {
    List() {
      ListItem() {
        Column() {
          List({ space: CommonConstants.SPACE_12 }) {
            ForEach(this.hotFeedList, (item: LearningResource, index?: number) => {
              ListItem() {
                NavRouter({ name: 'articleDetail', param: item }) {
                  FeedCardView({ feedItem: item })
                }
              }
              .padding({
                left: index && index % new BreakpointType({
                  sm: 2,
                  md: 3,
                  lg: 6
                }).getValue(this.currentBreakpoint) !== 0 ? $r('app.float.md_padding_margin') : 0,
              })
            }, (item: LearningResource) => item.id)
          }
          .lanes(new BreakpointType({
            sm: 2,
            md: 3,
            lg: 6
          }).getValue(this.currentBreakpoint))
          .alignListItem(ListItemAlign.Start)
          .scrollBar(BarState.Off)
        }
      }

      if (this.discoverModel.loadingFeedStatus === LoadingStatus.LOADING) {
        ListItem() {
          LoadingMoreLayout()
        }
      }

      if (!this.discoverModel.hasNextFeed) {
        ListItem() {
          NoMoreLayout()
        }
      }
    }
    .onReachEnd(() => {
      this.isListReachEnd = true;
    })
    .parallelGesture(
      PanGesture({ direction: PanDirection.Up, distance: LOAD_MORE_MIN_DRAG_DISTANCE })
        .onActionStart(() => {
          if (this.isListReachEnd) {
            this.discoverModel.loadMoreFeed();
            this.isListReachEnd = false;
          }
        })
    )
    .padding({
      left: $r('app.float.md_padding_margin'),
      right: $r('app.float.md_padding_margin')
    })
    .width(CommonConstants.FULL_PERCENT)
    .scrollBar(BarState.Off)
    .layoutWeight(1)
  }
}
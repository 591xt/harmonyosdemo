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

import { ArticleSkeletonView, FeedSkeletonView } from '@ohos/uicomponents';
import { BreakpointType, BreakpointTypeEnum, CommonConstants } from '@ohos/utils';

const MORE_DEFAULT_WIDTH = '8%';
const TITLE_DEFAULT_WIDTH = '43%';
const FEED_VISIBLE_LENGTH = 6;
const ARTICLE_VISIBLE_LENGTH = 6;
const SWIPER_ASPECT_RATIO = 2.4;
const SWIPER_MARGIN_MD = 200;
const SWIPER_MARGIN_LG = 100;
const COUNT_TWO = 2;
const COUNT_THREE = 3;
const FEED_CARD_WIDTH_SM = '46.6%';
const FEED_CARD_WIDTH_MD = '23.9%';
const FEED_CARD_WIDTH_LG = '16.6%';

@Component
export struct DiscoverSkeletonView {
  hotFeeds: Array<Number> = new Array(FEED_VISIBLE_LENGTH).fill(1).map((v: number, k: number) => ++k);
  articles: Array<Number> = new Array(ARTICLE_VISIBLE_LENGTH).fill(1).map((v: number, k: number) => ++k);
  @State columnOpacity: number = 1;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;

  startAnimation(): void {
    animateTo(CommonConstants.SKELETON_ANIMATION, () => {
      this.columnOpacity = 0.5;
    });
  }

  build() {
    Column() {
      List({ space: CommonConstants.SPACE_16 }) {
        ListItem() {
          Swiper() {
            ForEach(this.hotFeeds, () => {
              Row() {
                Row()
                  .borderRadius($r('app.float.lg_border_radius'))
                  .backgroundColor($r('app.color.skeleton_color'))
                  .width(CommonConstants.FULL_PERCENT)
                  .height(CommonConstants.FULL_PERCENT)
              }
              .width(CommonConstants.FULL_PERCENT)
              .aspectRatio(SWIPER_ASPECT_RATIO)
              .padding({ right: $r('app.float.md_padding_margin') })
            })
          }
          .width(CommonConstants.FULL_PERCENT)
          .displayCount(new BreakpointType({ sm: 1, md: 1, lg: COUNT_TWO }).getValue(this.currentBreakpoint))
          .displayMode(SwiperDisplayMode.AUTO_LINEAR)
          .nextMargin(new BreakpointType<Length>({
            sm: 0,
            md: SWIPER_MARGIN_MD,
            lg: SWIPER_MARGIN_LG
          }).getValue(this.currentBreakpoint))
        }

        ListItem() {
          Column() {
            Row() {
              Row()
                .width(TITLE_DEFAULT_WIDTH)
                .height($r('app.float.header_font_size'))
                .backgroundColor($r('app.color.skeleton_color'))
                .padding({
                  left: $r('app.float.md_padding_margin'),
                })
              Row()
                .width(MORE_DEFAULT_WIDTH)
                .height($r('app.float.header_font_size'))
                .backgroundColor($r('app.color.skeleton_color'))
            }
            .width(CommonConstants.FULL_PERCENT)
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({
              bottom: $r('app.float.sm_padding_margin')
            })

            List({ space: CommonConstants.SPACE_12 }) {
              ForEach(this.hotFeeds, () => {
                ListItem() {
                  FeedSkeletonView()
                }
                .padding({ right: $r('app.float.md_padding_margin') })
                .width(new BreakpointType<ResourceStr>({
                  sm: FEED_CARD_WIDTH_SM,
                  md: FEED_CARD_WIDTH_MD,
                  lg: FEED_CARD_WIDTH_LG
                }).getValue(this.currentBreakpoint))
              }, (item: number) => item.toString())
            }
            .padding({
              right: this.currentBreakpoint === BreakpointTypeEnum.LG ? $r('app.float.md_padding_margin') : 0
            })
            .scrollBar(BarState.Off)
            .listDirection(Axis.Horizontal)

            Row()
              .backgroundColor($r('app.color.skeleton_color'))
              .width(TITLE_DEFAULT_WIDTH)
              .height($r('app.float.header_font_size'))
              .margin({
                top: $r('app.float.lg_padding_margin'),
                bottom: $r('app.float.sm_padding_margin')
              })

            List({ space: CommonConstants.SPACE_12 }) {
              ForEach(this.articles, () => {
                ListItem() {
                  ArticleSkeletonView()
                }
                .padding({ right: $r('app.float.md_padding_margin') })
              }, (item: number) => item.toString())
            }
            .padding({
              right: this.currentBreakpoint === BreakpointTypeEnum.SM ? 0 : $r('app.float.md_padding_margin')
            })
            .lanes(new BreakpointType({ sm: 1, md: COUNT_TWO, lg: COUNT_THREE }).getValue(this.currentBreakpoint))
          }
          .alignItems(HorizontalAlign.Start)
        }
      }
      .scrollBar(BarState.Off)
    }
    .height(CommonConstants.FULL_PERCENT)
    .opacity(this.columnOpacity)
    .onAppear(() => {
      this.startAnimation();
    })
  }
}
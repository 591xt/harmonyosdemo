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

import deviceInfo from '@ohos.deviceInfo';
import { SearchView } from '@ohos/search';
import { BreakpointConstants, CommonConstants } from '@ohos/commons';
import { FooterTab, FooterTabViewModel } from '../viewmodel/FooterTabViewModel';
import { HomeConstants } from '../constants/HomeConstants';
import { HomeHeader } from './HomeHeader';
import { HomeContent } from './HomeContent';

@Component
export struct Home {
  @State currentBottomIndex: number = 0;
  @State currentTopIndex: number = 0;
  @State isSearching: boolean = false;
  @State currentSideBarIndex: number = 0;
  @State scrollHeight: number = 0;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  private tabList: FooterTab[] = new FooterTabViewModel().getTabList();
  private scroller: Scroller = new Scroller();
  private sideScroller: Scroller = new Scroller();

  @Builder
  BottomTabBuilder(item: FooterTab, index: number) {
    Column() {
      Image(index !== this.currentBottomIndex ? (this.currentTopIndex === 2 && !this.isSearching ? item.getIconWhite() :
        item.getIcon()) : item.getIconSelected())
        .width($r('app.float.icon_tab_width'))
        .height($r('app.float.icon_tab_height'))
      Text(item.getName())
        .fontSize($r('app.float.tab_font_size'))
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
        .fontColor(index === this.currentBottomIndex ? $r('app.color.tab_sel_color') : (this.currentTopIndex === 2 &&
          !this.isSearching ? Color.White : Color.Black))
        .margin({ top: $r('app.float.tab_top_margin') })
        .opacity(index === this.currentBottomIndex ? CommonConstants.TEXT_OPACITY[3] : CommonConstants.TEXT_OPACITY[0])
    }
    .padding({ bottom: this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG && deviceInfo.deviceType !==
      CommonConstants.DEVICE_TYPES[0] ? $r('app.float.bottom_navigation') : 0 })
    .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? $r('app.float.tab_height_lg') :
      CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && this.currentTopIndex === 2) {
        // The immersive design of the 2in1 home page is displayed when the top tab is switched to 2.
        SideBarContainer(SideBarContainerType.Overlay) {
          Column() {
            Blank()
              .layoutWeight(1)
            List() {
              ForEach(this.tabList, (item: FooterTab, index: number) => {
                ListItem() {
                  Column() {
                    Image(index !== this.currentSideBarIndex ? (this.isSearching ? item.getIcon() : item.getIconWhite())
                      : item.getIconSelected())
                      .width($r('app.float.icon_tab_width'))
                      .height($r('app.float.icon_tab_height'))
                    Text(item.getName())
                      .fontSize($r('app.float.tab_font_size'))
                      .fontWeight(CommonConstants.FONT_WEIGHT_500)
                      .fontColor(index === this.currentSideBarIndex ? $r('app.color.tab_sel_color') :
                        (this.isSearching ? Color.Black : Color.White))
                      .margin({ top: $r('app.float.tab_top_margin') })
                      .opacity(index === this.currentSideBarIndex ? CommonConstants.TEXT_OPACITY[3] :
                        CommonConstants.TEXT_OPACITY[0])
                  }
                  .height(HomeConstants.SIDE_ICON_LIST_HEIGHT)
                  .width(CommonConstants.FULL_PERCENT)
                  .justifyContent(FlexAlign.Center)
                }
                .onClick(() => {
                  this.currentSideBarIndex = index;
                })
              }, (item: FooterTab, index: number) => index + JSON.stringify(item))
            }
            .layoutWeight(2)
            Blank()
              .layoutWeight(1)
          }
          .height(CommonConstants.FULL_PERCENT)
          .width(CommonConstants.FULL_PERCENT)
          // Set transparent background color.
          .backgroundColor(this.isSearching ? Color.White : $r('app.color.side_bar_background'))

          // Main content area on the home page.
          Stack() {
            Scroll(this.sideScroller) {
              Column() {
                HomeContent({ currentTopIndex: this.currentTopIndex })
                  .visibility(!this.isSearching ? Visibility.Visible : Visibility.None)

                SearchView({ isSearching: $isSearching, currentTopIndex: $currentTopIndex })
                  .visibility(!this.isSearching ? Visibility.None : Visibility.Visible)
              }
              .width(CommonConstants.FULL_PERCENT)
            }
            .scrollBar(BarState.Off)
            .height(CommonConstants.FULL_PERCENT)
            // Obtains the sliding offset on the y axis during sliding.
            .onScroll(() => {
              this.scrollHeight = this.sideScroller.currentOffset().yOffset;
            })

            // Control the top-level display of the top tab bar.
            HomeHeader({ currentTopIndex: $currentTopIndex, isSearching: $isSearching, scrollHeight: $scrollHeight })
              .visibility(!this.isSearching ? Visibility.Visible : Visibility.None)
              .padding({ left: $r('app.float.side_bar_width') })
          }
          .height(CommonConstants.FULL_PERCENT)
          .width(CommonConstants.FULL_PERCENT)
          .alignContent(Alignment.Top)
        }
        .showSideBar(true)
        .showControlButton(false)
        .sideBarWidth($r('app.float.side_bar_width'))
        .autoHide(false)
        .minSideBarWidth($r('app.float.side_bar_width'))
        .maxSideBarWidth($r('app.float.side_bar_width'))
      } else if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG && this.currentTopIndex === 2) {
        // The immersive design of the phone and foldable phone home page is displayed when the top tab is switched to 2.
        Column() {
          Tabs({ barPosition: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarPosition.Start :
            BarPosition.End }) {
            ForEach(this.tabList, (item: FooterTab, index: number) => {
              TabContent() {
                Stack() {
                  Scroll(this.sideScroller) {
                    Column() {
                      HomeContent({ currentTopIndex: this.currentTopIndex })
                        .visibility(!this.isSearching ? Visibility.Visible : Visibility.None)

                      SearchView({ isSearching: $isSearching, currentTopIndex: $currentTopIndex })
                        .visibility(!this.isSearching ? Visibility.None : Visibility.Visible)
                    }
                    .width(CommonConstants.FULL_PERCENT)
                  }
                  .scrollBar(BarState.Off)
                  .height(CommonConstants.FULL_PERCENT)
                  .onScroll(() => {
                    this.scrollHeight = this.sideScroller.currentOffset().yOffset;
                  })

                  HomeHeader({ currentTopIndex: $currentTopIndex, isSearching: $isSearching, scrollHeight: $scrollHeight
                    })
                    .visibility(!this.isSearching ? Visibility.Visible : Visibility.None)
                }
                .height(CommonConstants.FULL_PERCENT)
                .width(CommonConstants.FULL_PERCENT)
                .alignContent(Alignment.Top)
              }
              .tabBar(this.BottomTabBuilder(item, index))
            }, (item: FooterTab, index: number) => index + JSON.stringify(item))
          }
          .barWidth(CommonConstants.FULL_PERCENT)
          .barHeight($r('app.float.tab_size'))
          .backgroundColor(!this.isSearching ? $r('app.color.home_content_background') : Color.White)
          .onChange((index: number) => {
            this.currentBottomIndex = index;
          })
          .scrollable(false)
        }
      } else {
        // Non-immersive design for the home page.
        Column() {
          Tabs({ barPosition: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarPosition.Start :
            BarPosition.End }) {
            ForEach(this.tabList, (item: FooterTab, index: number) => {
              TabContent() {
                Column() {
                  HomeHeader({ currentTopIndex: $currentTopIndex, isSearching: $isSearching, scrollHeight: $scrollHeight
                  })
                    .visibility(!this.isSearching ? Visibility.Visible : Visibility.None)

                  Scroll(this.scroller) {
                    Column() {
                      HomeContent({ currentTopIndex: this.currentTopIndex })
                        .visibility(!this.isSearching ? Visibility.Visible : Visibility.None)

                      SearchView({ isSearching: $isSearching, currentTopIndex: $currentTopIndex })
                        .visibility(!this.isSearching ? Visibility.None : Visibility.Visible)
                    }
                    .width(CommonConstants.FULL_PERCENT)
                  }
                  .layoutWeight(1)
                  .scrollBar(BarState.Off)
                }
                .height(CommonConstants.FULL_PERCENT)
                .width(CommonConstants.FULL_PERCENT)
              }
              .tabBar(this.BottomTabBuilder(item, index))
            }, (item: FooterTab, index: number) => index + JSON.stringify(item))
          }
          // Change the position and size of the tab at the bottom.
          .barWidth(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
            $r('app.float.bottom_tab_bar_width_lg') : CommonConstants.FULL_PERCENT)
          .barHeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? CommonConstants.FULL_PERCENT :
            (deviceInfo.deviceType === CommonConstants.DEVICE_TYPES[0] ? $r('app.float.tab_size_lg') :
            $r('app.float.tab_size')))
          .barMode(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarMode.Scrollable : BarMode.Fixed,
            { nonScrollableLayoutStyle: LayoutStyle.ALWAYS_CENTER })
          .barBackgroundColor($r('app.color.tab_background_color'))
          .vertical(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG)
          .onChange((index: number) => {
            this.currentBottomIndex = index;
          })
          .scrollable(false)
        }
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }
}
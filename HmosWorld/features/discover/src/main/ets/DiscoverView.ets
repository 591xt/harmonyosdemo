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

import common from '@ohos.app.ability.common';
import { EventTypeEnum, LearningResource, UserModel } from '@ohos/mine';
import { FailureLayout, LoadingMoreLayout, NoMoreLayout } from '@ohos/uicomponents';
import {
  BreakpointType,
  BreakpointTypeEnum,
  CommonConstants,
  LazyDataSource,
  LoadingStatus,
  ObservedArray
} from '@ohos/utils';
import { ArticleCardView } from './components/article/ArticleCardView';
import { FeedCardView } from './components/feed/FeedCardView';
import { DiscoverSkeletonView } from './components/skeleton/DiscoverSkeletonView';
import { DiscoverModel } from './model/DiscoverModel';
import { ArticleDetailView } from './components/ArticleDetailView';
import { FeedList } from './components/FeedList';

const context = (getContext(this) as common.UIAbilityContext);
const FEEDS_VISIBLE_LENGTH = 6;
const FEED_CARD_WIDTH_SM = '46.6%';
const FEED_CARD_WIDTH_MD = '23.9%';
const FEED_CARD_WIDTH_LG = '16.6%';
const SWIPER_ASPECT_RATIO = 2.4;
const SWIPER_MARGIN_MD = 200;
const SWIPER_MARGIN_LG = 100;
const COUNT_TWO = 2;
const COUNT_THREE = 3;
const LOAD_MORE_MIN_DRAG_DISTANCE = 60;

@Component
export struct DiscoverView {
  @Consume('appPathStack') appPathStack: NavPathStack;
  @Consume('discoverPathStack') discoverPathStack: NavPathStack;
  @State userModel: UserModel = UserModel.getInstance();
  @State discoverModel: DiscoverModel = DiscoverModel.getInstance();
  @State techArticleList: ObservedArray<LearningResource> = this.discoverModel.techArticleList;
  @State articlesDataSource: LazyDataSource<LearningResource> = new LazyDataSource();
  @State hotFeedList: ObservedArray<LearningResource> = this.discoverModel.hotFeedList;
  @State collectedIds: ObservedArray<string> = this.userModel.collectedIds;
  @State likedIds: ObservedArray<string> = this.userModel.likedIds;
  @State isListReachEnd: boolean = false;
  @StorageLink('getHomeResource') @Watch('handleGetHomeResourceChanged') getHomeResource: boolean = false;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State webViewController?: WebviewController = undefined;
  @State loadingStatus: LoadingStatus = LoadingStatus.OFF;

  aboutToAppear() {
    this.userModel.getUserData();
    this.loadResources();
  }

  initLazyData(): void {
    let length = this.articlesDataSource.totalCount();
    for (let i = length - 1; i >= 0; i--) {
      this.articlesDataSource.deleteData(i);
    }

    for (let i = 0; i < this.techArticleList.length; i++) {
      this.articlesDataSource.pushData(this.techArticleList[i])
    }
  }

  loadResources(): void {
    this.loadingStatus = LoadingStatus.LOADING;
    this.discoverModel.getHomeResources().then(() => {
      this.loadingStatus = LoadingStatus.SUCCESS;
      this.initLazyData();
      AppStorage.setOrCreate('getHomeResource', false);
    }).catch(() => {
      this.loadingStatus = LoadingStatus.FAILED;
    });
  }

  handleGetHomeResourceChanged(): void {
    if (!this.getHomeResource) {
      return;
    }
    this.loadResources();
  }

  onDestinationBack(): boolean {
    if (this.webViewController?.accessBackward()) {
      this.webViewController.backward();
    } else {
      this.discoverPathStack.pop();
    }
    return true;
  }

  jumpDetail(item: LearningResource): void {
    if (this.currentBreakpoint === BreakpointTypeEnum.LG) {
      this.discoverPathStack.pushPathByName('articleDetail', item);
    }
    else {
      this.appPathStack.pushPathByName('articleDetail', item);
    }
  }

  jumpList(): void {
    if (this.currentBreakpoint === BreakpointTypeEnum.LG) {
      this.discoverPathStack.pushPathByName('feedList', null);
    }
    else {
      this.appPathStack.pushPathByName('feedList', null);
    }
  }

  @Builder
  discoverRouter(name: string, param?: LearningResource) {
    if (name === 'feedList') {
      FeedList({ onDestinationBack: () => {
        this.discoverPathStack.pop();
      } })
    } else if (name === 'articleDetail') {
      ArticleDetailView({
        articleDetail: param,
        webViewController: $webViewController,
        onDestinationBack: () => this.onDestinationBack()
      })
    }
  }

  build() {
    Navigation(this.discoverPathStack) {
      Column() {
        Header()
        if (this.loadingStatus === LoadingStatus.LOADING) {
          DiscoverSkeletonView()
        }
        if (this.loadingStatus === LoadingStatus.FAILED) {
          FailureLayout({ handleReload: () => this.loadResources() })
        }
        if (this.loadingStatus === LoadingStatus.SUCCESS) {
          List({ space: CommonConstants.SPACE_16 }) {
            ListItem() {
              Banner({
                swiperData: this.discoverModel.swiperData,
                handleClick: (item: LearningResource) => this.jumpDetail(item)
              })
            }

            ListItem() {
              Column({ space: CommonConstants.SPACE_12 }) {
                HotFeeds({
                  hotFeedList: this.hotFeedList,
                  showMore: () => this.jumpList(),
                  handleClick: (item: LearningResource) => this.jumpDetail(item)
                })
                TechArticles({
                  articlesDataSource: this.articlesDataSource,
                  collectedIds: this.userModel.collectedIds,
                  likedIds: this.userModel.likedIds,
                  handleClick: (item: LearningResource) => this.jumpDetail(item)
                })
              }
            }

            if (this.discoverModel.loadingArticleStatus === LoadingStatus.LOADING) {
              ListItem() {
                LoadingMoreLayout()
              }
            }

            if (!this.discoverModel.hasNextArticle) {
              ListItem() {
                NoMoreLayout()
              }
            }
          }
          .scrollBar(BarState.Off)
          .onReachEnd(() => {
            this.isListReachEnd = true;
          })
          .layoutWeight(1)
          .parallelGesture(
            PanGesture({ direction: PanDirection.Up, distance: LOAD_MORE_MIN_DRAG_DISTANCE })
              .onActionStart(() => {
                if (this.isListReachEnd && this.discoverModel.hasNextArticle) {
                  this.discoverModel.loadMoreArticle().then((data) => {
                    for (let i = 0; i < data.length; i++) {
                      this.articlesDataSource.pushData(data[i]);
                    }
                  });
                  this.isListReachEnd = false;
                }
              })
          )
        }
      }
      .padding({
        top: AppStorage.get<number>('statusBarHeight'),
        left: new BreakpointType({
          sm: $r('app.float.md_padding_margin'),
          md: $r('app.float.xxl_padding_margin'),
          lg: $r('app.float.xxl_padding_margin')
        }).getValue(this.currentBreakpoint)
      })
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .navDestination(this.discoverRouter)
    .mode(NavigationMode.Stack)
  }
}

@Builder
function Header() {
  Row() {
    Text($r('app.string.discover'))
      .fontSize($r('app.float.header_font_size'))
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Start)
      .width(CommonConstants.FULL_PERCENT)
      .fontFamily(CommonConstants.HARMONY_HEITI_BOLD_FONT_FAMILY)
      .padding({ left: $r('app.float.md_padding_margin') })
  }
  .height($r('app.float.top_navigation_height'))
}

@Component
struct Banner {
  @Prop swiperData: LearningResource[];
  handleClick: (item: LearningResource) => void = () => {
  };
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  private swiperController: SwiperController = new SwiperController();

  build() {
    Swiper(this.swiperController) {
      ForEach(this.swiperData, (item: LearningResource) => {
        Row() {
          Image(item.bannerSrc)
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.FULL_PERCENT)
            .borderRadius($r('app.float.lg_border_radius'))
            .onClick(() => this.handleClick(item))
        }
        .width(CommonConstants.FULL_PERCENT)
        .aspectRatio(SWIPER_ASPECT_RATIO)
        .padding({ right: $r('app.float.md_padding_margin') })
      }, (item: LearningResource) => item.id)
    }
    .width(CommonConstants.FULL_PERCENT)
    .displayCount(new BreakpointType({ sm: 1, md: 1, lg: COUNT_TWO }).getValue(this.currentBreakpoint))
    .displayMode(SwiperDisplayMode.AUTO_LINEAR)
    .nextMargin(new BreakpointType<Length>({
      sm: 0,
      md: SWIPER_MARGIN_MD,
      lg: SWIPER_MARGIN_LG
    }).getValue(this.currentBreakpoint))
    .indicator(this.currentBreakpoint === BreakpointTypeEnum.SM ? Indicator.dot()
      .color($r('app.color.swiper_indicator_color'))
      .selectedColor($r('app.color.theme_blue_color')) : false)
    .autoPlay(true)
    .loop(true)
  }
}

@Component
struct HotFeeds {
  @ObjectLink hotFeedList: ObservedArray<LearningResource>;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  handleClick: (item: LearningResource) => void = () => {
  };
  showMore: () => void = () => {
  };

  build() {
    Column({ space: CommonConstants.SPACE_8 }) {
      Row() {
        Text($r('app.string.hot_feeds'))
          .padding({
            left: this.currentBreakpoint === BreakpointTypeEnum.SM ? $r('app.float.md_padding_margin') : 0,
          })
          .fontColor($r('app.color.theme_font_color'))
          .fontSize($r('app.float.lg_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
        Row() {
          Text($r('app.string.more'))
            .fontSize($r('app.float.md_font_size'))
            .padding({ right: $r('app.float.xs_padding_margin') })
            .fontColor($r('app.color.theme_font_color'))
            .opacity(CommonConstants.SECOND_LEVEL_OPACITY)

          Image($r('app.media.ic_public_arrow_right'))
            .objectFit(ImageFit.Contain)
            .opacity(CommonConstants.THIRD_LEVEL_OPACITY)
            .size({
              width: $r('app.float.more_arrow_icon_width'),
              height: $r('app.float.more_arrow_icon_height')
            })
        }
        .onClick(() => this.showMore())
      }
      .alignItems(VerticalAlign.Center)
      .padding({ right: new BreakpointType({
        sm: $r('app.float.md_padding_margin'),
        md: $r('app.float.xxl_padding_margin'),
        lg: $r('app.float.xxl_padding_margin')
      }).getValue(this.currentBreakpoint),
        top: $r('app.float.sm_padding_margin')
      })
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)

      List() {
        ForEach(this.hotFeedList.slice(0, FEEDS_VISIBLE_LENGTH), (item: LearningResource) => {
          ListItem() {
            FeedCardView({ feedItem: item })
              .onClick(() => this.handleClick(item))
          }
          .padding({ right: $r('app.float.md_padding_margin') })
          .width(new BreakpointType<ResourceStr>({
            sm: FEED_CARD_WIDTH_SM,
            md: FEED_CARD_WIDTH_MD,
            lg: FEED_CARD_WIDTH_LG
          }).getValue(this.currentBreakpoint))
        }, (item: LearningResource) => item.id)
      }
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }.padding({ right: this.currentBreakpoint === BreakpointTypeEnum.LG ? $r('app.float.md_padding_margin') : 0 })
  }
}

@Component
struct TechArticles {
  @ObjectLink articlesDataSource: LazyDataSource<LearningResource>;
  @Prop collectedIds: ObservedArray<string> = [];
  @Prop likedIds: ObservedArray<string> = [];
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  handleClick: (item: LearningResource) => void = () => {
  };

  isCollected(resourceId: string): boolean {
    return this.collectedIds.some((id: string) => id === resourceId);
  }

  isLiked(resourceId: string): boolean {
    return this.likedIds.some((id: string) => id === resourceId);
  }

  build() {
    Column({ space: CommonConstants.SPACE_8 }) {
      Text($r('app.string.technical_articles'))
        .fontSize($r('app.float.lg_font_size'))
        .width(CommonConstants.FULL_PERCENT)
        .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
        .fontWeight(FontWeight.Medium)
        .padding({
          left: this.currentBreakpoint === BreakpointTypeEnum.SM ? $r('app.float.md_padding_margin') : 0
        })
        .margin({
          top: $r('app.float.sm_padding_margin')
        })

      List({ space: CommonConstants.SPACE_12 }) {
        LazyForEach(this.articlesDataSource, (item: LearningResource) => {
          ListItem() {
            ArticleCardView({
              articleItem: item,
              isLiked: this.isLiked(item.id),
              isCollected: this.isCollected(item.id),
              onCollected: () => {
                context.eventHub.emit(EventTypeEnum.COLLECTED, {
                  resourceId: item.id,
                  resourceType: item.type,
                  actionValue: !this.isCollected(item.id)
                });
              },
              onLiked: () => {
                context.eventHub.emit(EventTypeEnum.LIKED, {
                  resourceId: item.id,
                  resourceType: item.type,
                  actionValue: !this.isLiked(item.id)
                });
              }
            })
              .reuseId(item.type.toString())
              .onClick(() => this.handleClick(item))
          }
          .padding({ right: $r('app.float.md_padding_margin') })
        }, (item: LearningResource) => item.id)
      }
      .lanes(new BreakpointType({ sm: 1, md: COUNT_TWO, lg: COUNT_THREE }).getValue(this.currentBreakpoint))
    }
    .padding({ right: this.currentBreakpoint === BreakpointTypeEnum.SM ? 0 : $r('app.float.md_padding_margin') })
  }
}
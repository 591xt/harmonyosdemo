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

import { ActionButtonView, ArticleCardButtonView } from '@ohos/uicomponents';
import { CommonConstants } from '@ohos/utils';
import { LearningResource } from '../model/LearningResource';

@Component
export struct ArticleCardView {
  @Prop isLiked: boolean = false;
  @Prop isCollected: boolean = false;
  @Prop isSelected: boolean = false;
  @ObjectLink articleItem: LearningResource;
  onCollected?: () => void;
  onLiked?: () => void;
  handleClick: () => void = () => {
  };

  build() {
    Row({ space: CommonConstants.SPACE_16 }) {
      Column() {
        Column() {
          Text(this.articleItem.title)
            .fontSize($r('app.float.title_font_size'))
            .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .opacity(CommonConstants.FIRST_LEVEL_OPACITY)
            .width(CommonConstants.FULL_PERCENT)
            .maxLines(CommonConstants.MAX_LINE_TWO)
            .margin({ bottom: $r('app.float.ss_padding_margin') })

          Text(this.articleItem.brief)
            .fontSize($r('app.float.brief_font_size'))
            .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
            .opacity(CommonConstants.SECOND_LEVEL_OPACITY)
            .maxLines(1)
            .width(CommonConstants.FULL_PERCENT)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Row() {
          ActionButtonView({
            imgResource: $r('app.media.ic_eye_open'),
            count: this.articleItem.viewsCount,
            textWidth: $r('app.float.view_count_icon_width')
          })

          ArticleCardButtonView({
            clickAnimationPath: 'common/lottie/liked_lottie.json',
            cancelAnimationPath: 'common/lottie/cancel_liked_lottie.json',
            isClicked: this.isLiked,
            count: this.articleItem.likesCount,
            articleId: this.articleItem.id,
            textWidth: $r('app.float.like_icon_width'),
            type: 'like',
            onClicked: this.onLiked,
            normalImage: $r('app.media.btn_good_normal'),
            onImage: $r('app.media.btn_good_on')
          })

          ArticleCardButtonView({
            clickAnimationPath: 'common/lottie/collected_lottie.json',
            cancelAnimationPath: 'common/lottie/cancel_collect_lottie.json',
            isClicked: this.isCollected,
            count: this.articleItem.collectionCount,
            articleId: this.articleItem.id,
            textWidth: $r('app.float.star_icon_width'),
            type: 'collect',
            onClicked: this.onCollected,
            normalImage: $r('app.media.btn_favorites_normal'),
            onImage: $r('app.media.btn_favorites_on')
          })
        }
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .height(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceAround)

      Stack({ alignContent: Alignment.BottomEnd }) {
        Image(this.articleItem.headerImageUrl)
          .height($r('app.float.resource_image_height'))
          .width($r('app.float.resource_image_width'))
          .borderRadius($r('app.float.image_border_radius'))
          .alt($r('app.media.img_placeholder'))
          .objectFit(ImageFit.Cover)
        Text($r('app.string.article'))
          .fontSize($r('app.float.small_font_size'))
          .margin({
            right: $r('app.float.resource_type_font_padding'),
            bottom: $r('app.float.resource_type_font_padding')
          })
          .padding({
            left: $r('app.float.resource_type_font_margin_left_right'),
            right: $r('app.float.resource_type_font_margin_left_right'),
            top: $r('app.float.resource_type_font_margin_top_bottom'),
            bottom: $r('app.float.resource_type_font_margin_top_bottom')
          })
          .backgroundColor($r('app.color.hmos_regular_gray'))
          .borderRadius($r('app.float.resource_type_font_border_radius'))
          .fontColor($r('app.color.hmos_color_white'))
      }
      .height($r('app.float.resource_image_height'))
      .width($r('app.float.resource_image_width'))
    }
    .padding($r('app.float.md_padding_margin'))
    .borderRadius($r('app.float.large_border_radius'))
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .linearGradient(this.isSelected ? {
      angle: '270deg',
      colors: [['#FAFAFA', '0'], ['#DCEAF9', '1']]
    } : { colors: [] })
    .height($r('app.float.card_height'))
    .onClick(this.handleClick)
  }
}

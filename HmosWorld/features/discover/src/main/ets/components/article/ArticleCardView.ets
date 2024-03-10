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
import { ActionButtonView, ArticleCardButtonView } from '@ohos/uicomponents';
import { CommonConstants } from '@ohos/utils';

@Reusable
@Component
export struct ArticleCardView {
  @Prop isCollected: boolean = false;
  @Prop isLiked: boolean = false;
  @Prop articleItem: LearningResource = new LearningResource();
  onCollected?: () => void;
  onLiked?: () => void;

  aboutToReuse(params: Record<string, Object>): void {
    this.isCollected = params.isCollected as boolean;
    this.isLiked = params.isLiked as boolean;
  }

  build() {
    Row({ space: CommonConstants.SPACE_16 }) {
      Column() {
        Column() {
          Text(this.articleItem.title)
            .fontSize($r('app.float.md_font_size'))
            .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .opacity(CommonConstants.FIRST_LEVEL_OPACITY)
            .maxLines(CommonConstants.MAX_LINE_TWO)
            .margin({ bottom: $r('app.float.xs_padding_margin') })

          Text(this.articleItem.brief)
            .fontSize($r('app.float.sm_font_size'))
            .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
            .opacity(CommonConstants.SECOND_LEVEL_OPACITY)
            .maxLines(1)
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
            .onClick(() => {
              this.onLiked?.();
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
            .onClick(() => {
              this.onCollected?.();
            })
        }
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .height(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceAround)

      Image(this.articleItem.headerImageUrl)
        .interpolation(ImageInterpolation.High)
        .height($r('app.float.article_card_image_height'))
        .width($r('app.float.article_card_image_width'))
        .borderRadius($r('app.float.md_border_radius'))
        .alt($r('app.media.img_placeholder'))
        .objectFit(ImageFit.Cover)
    }
    .padding($r('app.float.md_padding_margin'))
    .borderRadius($r('app.float.lg_border_radius'))
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.float.article_card_height'))
  }
}
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

import CommonConstants from '../common/constants/CommonConstants';

@Component
export default struct DetailItemComponent {
  @Link topContent: string;
  @Link bottomContent: string;
  private componentId: number = CommonConstants.PHONE_COMPONENTS_ID;
  private bottomSubtitle: Resource = $r('app.string.item_personal_email');
  private leftIcon: Resource = $r('app.media.ic_phone_icon');
  private rightIcon: Resource = $r('app.media.ic_message');

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.getTopContent())
            .fontColor(Color.Black)
            .fontSize($r('app.float.details_item_font_size'))
            .fontWeight(500)
            .margin({ bottom: $r('app.float.details_item_margin') })
          Text(this.getBottomContent())
            .fontColor($r('app.color.font_color'))
            .fontSize($r('app.float.details_bottom_item_size'))
            .fontWeight(400)
            .opacity(0.6)
        }
        .width(CommonConstants.DETAIL_ITEM_WIDTH)
        .alignItems(HorizontalAlign.Start)

        Row() {
          if (this.componentId !== CommonConstants.Note_COMPONENTS_ID) {
            if (this.componentId === CommonConstants.PHONE_COMPONENTS_ID) {
              Image(this.leftIcon)
                .width($r('app.float.details_item_size'))
                .height($r('app.float.details_item_size'))
                .objectFit(ImageFit.Contain)
                .margin({ right: $r('app.float.details_margin_right') })
            }
            Image(this.rightIcon)
              .width($r('app.float.details_item_size'))
              .height($r('app.float.details_item_size'))
              .objectFit(ImageFit.Contain)
          }
        }
        .layoutWeight(CommonConstants.WEIGHT)
        .justifyContent(FlexAlign.End)
      }
      .height($r('app.float.details_item_height'))

      Divider()
        .height($r('app.float.divider_height'))
        .backgroundColor($r('app.color.list_divider'))
    }
  }

  getTopContent(): string {
    if (this.componentId === CommonConstants.PHONE_COMPONENTS_ID && this.topContent.length === 11) {
      let phoneNumberStr = '';
      for (let i = 0; i < this.topContent.length; i++) {
        if (i === 2 || i === 6) {
          phoneNumberStr += this.topContent[i] + ' ';
        } else {
          phoneNumberStr += this.topContent[i];
        }
      }
      return phoneNumberStr;
    } else {
      return this.topContent;
    }
  }

  getBottomContent(): string | Resource {
    if (this.componentId === CommonConstants.PHONE_COMPONENTS_ID) {
      return this.bottomContent;
    } else {
      return this.bottomSubtitle;
    }
  }
}
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

@Extend(Text)
function setTextStyle() {
  .width(CommonConstants.PERCENTAGE_MAX)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.bottom_bar_font_color'))
  .fontSize($r('app.float.bottom_bar_font_size'))
}

@Extend(Image)
function setImageStyle() {
  .width($r('app.float.bottom_bar_image_size'))
  .height($r('app.float.bottom_bar_image_size'))
  .margin($r('app.float.bottom_bar_image_margin'))
}

@Component
export default struct BottomBarComponent {
  private isAll: boolean = false;
  private pageId: string = '';
  private leftClickEvent: (isAll?: boolean) => void = () => {
  };
  private rightClickEvent: () => void = () => {
  };
  private leftIcon: Resource = $r('app.media.ic_edit');
  private leftSubtitle: Resource = $r('app.media.ic_delete');
  private rightIcon: Resource = $r('app.media.ic_delete');
  private rightSubtitle: Resource = $r('app.string.delete_text');

  build() {
    Column() {
      Divider()
        .height($r('app.float.divider_height'))
        .backgroundColor($r('app.color.list_divider'))
      Row() {
        Column() {
          Image(this.leftIcon)
            .setImageStyle()
          Text(this.leftSubtitle)
            .setTextStyle()
        }
        .onClick(() => {
          if (this.pageId === CommonConstants.DELETE_PAGE_ID) {
            this.isAll = !this.isAll;
          }
          this.leftClickEvent(this.isAll);
        })
        .width(CommonConstants.BOTTOM_COMPONENT_WIDTH)

        Column() {
          Image(this.rightIcon)
            .setImageStyle()
          Text(this.rightSubtitle)
            .setTextStyle()
        }
        .width(CommonConstants.BOTTOM_COMPONENT_WIDTH)
        .onClick(() => this.rightClickEvent())
      }
      .width(CommonConstants.PERCENTAGE_MAX)
      .height($r('app.float.bar_bottom_height'))
      .backgroundColor($r('app.color.theme_background'))
      .justifyContent(FlexAlign.End)
    }
  }
}
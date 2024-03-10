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
import { ListItemData } from '../viewmodel/ListItemData';

@Component
export struct ListItemComponent {
  private itemInfo: ListItemData = {
    id: 0,
    photo: $r('app.media.ic_men'),
    name: '',
    checked: false
  };
  private isCanCheck = false;
  private onCheck: () => void = () => {
  };

  build() {
    Column() {
      Column() {
        Row() {
          Image(this.itemInfo.photo)
            .objectFit(ImageFit.Contain)
            .width($r('app.float.image_width'))
            .height($r('app.float.image_height'))
            .margin({
              left: $r('app.float.list_image_left'),
              right: $r('app.float.list_image_right')
            })
          Column() {
            Text(this.itemInfo.name.toString())
              .fontSize($r('app.float.list_item_title'))
              .fontColor($r('app.color.list_item_title'))
              .fontWeight(FontWeight.Bolder)
              .maxLines(CommonConstants.TITLE_MAX_LINES)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
          }
          .layoutWeight(CommonConstants.TITLE_LAYOUT_WEIGHT)
          .alignItems(HorizontalAlign.Start)

          if (this.isCanCheck) {
            Checkbox()
              .select(this.itemInfo.checked)
              .selectedColor($r('app.color.selected_font_color'))
              .onChange(() => {
                this.onCheck();
              })
              .width($r('app.float.checkbox_size'))
              .height($r('app.float.checkbox_size'))
          }
        }
        .height($r('app.float.list_item_height'))

        if (this.isCanCheck) {
          Divider()
            .height($r('app.float.divider_height'))
            .backgroundColor($r('app.color.list_divider'))
            .margin({ left: CommonConstants.CONTACTS_LIST_DIVIDER })
        }
      }
    }
  }
}
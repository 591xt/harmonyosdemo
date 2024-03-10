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
import PageViewModel from '../viewmodel/PageViewModel';
import { ListItemData } from '../viewmodel/ListItemData';
import { ListItemComponent } from './ListItemComponent';

@Component
export struct ListAreaComponent {
  @Link contactData: Array<ListItemData>;

  build() {
    Column() {
      List() {
        ForEach(this.contactData, (item: ListItemData) => {
          ListItem() {
            ListItemComponent({ itemInfo: item })
          }
          .onClick(() => {
            PageViewModel.redirectDetailPage(item);
          })
        }, (item: ListItemData) => JSON.stringify(item))
      }
      .scrollBar(BarState.Off)
      .width(CommonConstants.LIST_WIDTH_PERCENT)
      .height(CommonConstants.PERCENTAGE_HEIGHT_MAX)
      .margin({ bottom: $r('app.float.list_area_height') })
    }
    .width(CommonConstants.PERCENTAGE_MAX)
  }
}
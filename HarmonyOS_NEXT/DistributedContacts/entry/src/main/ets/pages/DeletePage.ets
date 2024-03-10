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

import distributedKVStore from '@ohos.data.distributedKVStore';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../common/constants/CommonConstants';
import CheckEmptyUtils from '../common/util/CheckEmptyUtils';
import BottomBarComponent from '../view/BottomBarComponent';
import PageViewModel from '../viewmodel/PageViewModel';
import Logger from '../common/util/Logger';
import { DeletePageViewModel } from '../viewmodel/DeletePageViewModel';
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { ListItemComponent } from '../view/ListItemComponent';
import { GlobalContext } from '../common/util/GlobalContext';
import { ListItemData } from '../viewmodel/ListItemData';
import { DeleteDialog } from '../view/DeleteDialog';

const TAG: string = 'DeletePage';

@Entry
@Component
struct DeletePage {
  @State isSelectAll: boolean = false;
  @State checkList: Array<ListItemData> = [];
  @State count: number = 0;
  private deletePageViewModel: DeletePageViewModel = new DeletePageViewModel();
  contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      cancel: () => {
        this.deletePageViewModel.cancelDialog();
      },
      confirm: () => {
        this.batchDeleteButton();
      },
      promptMessage: $r('app.string.batch_delete_text'),
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: {
      dx: $r('app.float.dialog_dx'),
      dy: $r('app.float.dialog_dy')
    },
    customStyle: false
  });

  aboutToAppear() {
    this.initializeData();
  }

  /**
   * Initialize edit page data.
   */
  initializeData(): void {
    this.contactsDataBase.getEntries(
      CommonConstants.CONTACTS_DATABASE_KEY,
      (err: BusinessError, entries: distributedKVStore.Entry[]) => {
        Logger.info(TAG, `initializeData entries: ${JSON.stringify(entries)}`);
        if (err) {
          Logger.error(`Fail to get Entries, error message is ${JSON.stringify(err)}`);
          return;
        }
        this.checkList = PageViewModel.getData(entries);
      });
  }

  /**
   * Deleting selected contacts in batches.
   */
  batchDeleteButton(): void {
    let keys: string[] = [];
    this.checkList.forEach((item: ListItemData) => {
      if (item.checked) {
        let contactsKey: string = CommonConstants.CONTACTS_DATABASE_KEY + item.name;
        keys.push(contactsKey);
      }
    });
    Logger.info(TAG, `batchDeleteButton keys: ${JSON.stringify(keys)}`);
    // Batch delete.
    this.contactsDataBase.deleteBatch(keys, (err: BusinessError) => {
      if (err) {
        Logger.error(TAG, `Fail to delete Batch, code message is ${JSON.stringify(err)}`);
        return;
      }
      promptAction.showToast({
        message: $r('app.string.prompt_message_deleted'),
        duration: CommonConstants.PROMPT_DURATION
      });
      router.pushUrl({
        url: CommonConstants.LIST_PAGE_URL
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `pushUrl failed, code message is ${JSON.stringify(err)}`);
      });
    });
  }

  build() {
    Column() {
      this.NavigationTitle()
      Column() {
        List() {
          ForEach(this.checkList, (item: ListItemData) => {
            ListItem() {
              ListItemComponent({
                itemInfo: item,
                isCanCheck: true,
                onCheck: () => {
                  item.checked = !item.checked;
                  item.checked ? this.count++ : this.count--;
                }
              })
            }
          }, (item: ListItemData) => JSON.stringify(item))
        }
        .scrollBar(BarState.Off)
        .width(CommonConstants.LIST_WIDTH_PERCENT)
        .height(CommonConstants.PERCENTAGE_MAX)
      }
      .layoutWeight(CommonConstants.WEIGHT)

      BottomBarComponent({
        leftClickEvent: (isAll) => {
          if (!CheckEmptyUtils.isEmptyObj(PageViewModel)) {
            this.checkList = isAll ? PageViewModel.getSelectAll(this.checkList)
              : PageViewModel.getUnSelectAll(this.checkList);
            this.count = PageViewModel.getSelectCount(this.checkList);
          }
        },
        rightClickEvent: () => {
          this.count === 0 ? this.deletePageViewModel.unCheckedContact() : this.dialogController.open();
        },
        pageId: CommonConstants.DELETE_PAGE_ID,
        leftIcon: $r('app.media.ic_public_select'),
        leftSubtitle: $r('app.string.bottom_text_all_selected'),
        rightIcon: $r('app.media.ic_delete'),
        rightSubtitle: $r('app.string.bottom_text_deletion')
      })
    }
    .width(CommonConstants.PERCENTAGE_MAX)
    .height(CommonConstants.PERCENTAGE_MAX)
    .backgroundColor($r('app.color.detail_page_background'))
  }

  @Builder
  NavigationTitle() {
    Row() {
      Image($r('app.media.ic_close'))
        .height($r('app.float.icon_close_size'))
        .width($r('app.float.icon_close_size'))
        .margin({ right: $r('app.float.icon_close_margin_right') })
        .onClick(() => {
          router.back();
        })
      Text($r('app.string.contacts_select'))
        .fontColor($r('app.color.navigation_title'))
        .fontSize($r('app.float.detail_navigation_title'))
      Text(`${this.count}`)
        .fontColor($r('app.color.navigation_title'))
        .fontSize($r('app.float.detail_navigation_title'))
      Text($r('app.string.selected_text'))
        .fontColor($r('app.color.navigation_title'))
        .fontSize($r('app.float.detail_navigation_title'))
    }
    .width(CommonConstants.PAGE_TITLE_WIDTH)
    .height($r('app.float.delete_title_height'))
    .justifyContent(FlexAlign.Start)
  }
}
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

import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../common/constants/CommonConstants';
import DetailItemComponent from '../view/DetailItemComponent';
import BottomBarComponent from '../view/BottomBarComponent';
import ContactData from '../viewmodel/ContactData';
import Logger from '../common/util/Logger';
import { DetailPageViewModel } from '../viewmodel/DetailPageViewModel';
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { GlobalContext } from '../common/util/GlobalContext';
import { DeleteDialog } from '../view/DeleteDialog';

const TAG: string = 'DetailPage';

@Entry
@Component
struct ContactsDetail {
  @State name: string = '';
  @State telephony: string = '';
  @State email: string = '';
  @State remarks: string = '';
  @State address: string = '';
  private detailPageViewModel: DetailPageViewModel = new DetailPageViewModel();
  contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      cancel: () => {
        this.detailPageViewModel.cancelDialog();
      },
      confirm: () => {
        this.detailPageViewModel.deleteContactButton(this.name);
      },
      promptMessage: $r('app.string.delete_dialog_text')
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
   * Initialize detail page data.
   */
  initializeData(): void {
    let params = router.getParams() as Record<string, Object>;
    // Get contact details.
    this.contactsDataBase.get(params.key as string, (err: BusinessError, data) => {
      if (err) {
        Logger.error(TAG, `DetailPage.ets Fail to get, error message is ${JSON.stringify(err)}`);
        return;
      }
      let contactsData: ContactData = JSON.parse(data as string);
      this.name = contactsData.name as string;
      this.address = contactsData.address as string;
      this.telephony = contactsData.telephony as string;
      this.email = contactsData.email as string;
      this.remarks = contactsData.remarks as string;
    });
  }

  build() {
    Column() {
      Row() {
        this.NavigationTitle()
      }
      .width(CommonConstants.PERCENTAGE_MAX)
      .height(CommonConstants.DETAIL_TOP_HEIGHT)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)

      this.RankList()
      BottomBarComponent({
        leftClickEvent: () => {
          this.detailPageViewModel.redirectEditPage(
            this.name,
            this.address,
            this.telephony,
            this.email,
            this.remarks
          );
        },
        rightClickEvent: () => {
          this.dialogController.open();
        },
        pageId: CommonConstants.DETAIL_PAGE_ID,
        leftIcon: $r('app.media.ic_edit'),
        leftSubtitle: $r('app.string.edit_text'),
        rightIcon: $r('app.media.ic_delete'),
        rightSubtitle: $r('app.string.delete_contact')
      })
    }
    .justifyContent(FlexAlign.End)
    .backgroundColor($r('app.color.details_bg'))
    .height(CommonConstants.PERCENTAGE_MAX)
  }

  @Builder
  NavigationTitle() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width($r('app.float.edit_icon_size'))
          .height($r('app.float.edit_icon_size'))
          .onClick(() => {
            this.detailPageViewModel.redirectListPage();
          })
      }
      .layoutWeight(CommonConstants.WEIGHT)
    }
    .height($r('app.float.detail_navigation_height'))
    .margin({ left: $r('app.float.image_spacing_margin') })
  }

  @Builder
  RankList() {
    Column() {
      Image($r('app.media.ic_contacts_white'))
        .width($r('app.float.details_contacts_icon_size'))
        .height($r('app.float.details_contacts_icon_size'))
        .objectFit(ImageFit.Contain)
        .margin({ top: $r('app.float.details_contacts_icon_margin') })
      Text(this.name)
        .fontColor($r('app.color.contacts_icon_text_color'))
        .fontSize($r('app.float.contacts_icon_font_size'))
        .fontWeight(FontWeight.Medium)
        .margin({ top: $r('app.float.contacts_icon_font_margin') })
      Column() {
        DetailItemComponent({
          componentId: CommonConstants.PHONE_COMPONENTS_ID,
          topContent: this.telephony,
          bottomContent: this.address,
          leftIcon: $r('app.media.ic_phone_icon'),
          rightIcon: $r('app.media.ic_message')
        })
        DetailItemComponent({
          componentId: CommonConstants.Email_COMPONENTS_ID,
          topContent: this.email,
          bottomContent: this.address,
          bottomSubtitle: $r('app.string.item_personal_email'),
          rightIcon: $r('app.media.ic_right_arrow')
        })
        DetailItemComponent({
          componentId: CommonConstants.Note_COMPONENTS_ID,
          bottomContent: this.address,
          topContent: this.remarks,
          bottomSubtitle: $r('app.string.item_remark')
        })
      }
      .margin({ top: $r('app.float.contacts_detail_list_margin') })
      .width(CommonConstants.PERCENTAGE_MAX)
      .height(CommonConstants.PERCENTAGE_MAX)
    }
    .justifyContent(FlexAlign.Start)
    .padding({
      left: $r('app.float.details_padding'),
      right: $r('app.float.details_padding')
    })
    .borderRadius({
      topLeft: $r('app.float.details_border_radius'),
      topRight: $r('app.float.details_border_radius')
    })
    .width(CommonConstants.PERCENTAGE_MAX)
    .layoutWeight(CommonConstants.WEIGHT)
    .backgroundColor(Color.White)
  }
}
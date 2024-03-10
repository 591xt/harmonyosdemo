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

import AppContext from '@ohos.app.ability.common';
import router from '@ohos.router';
import CommonConstants from '../common/constants/CommonConstants';
import ContactData from '../viewmodel/ContactData';
import { EditPageViewModel } from '../viewmodel/EditPageViewModel';
import { GlobalContext } from '../common/util/GlobalContext';

@Entry
@Component
struct EditPage {
  @State isSelectAll: boolean = false;
  @State name: string = '';
  @State address: string = '';
  @State telephony: string = '';
  @State email: string = '';
  @State remarks: string = '';
  private isEdit: boolean = false;
  private editPageViewModel: EditPageViewModel = new EditPageViewModel();
  private textInputContext = getContext(this) as AppContext.UIAbilityContext;

  aboutToAppear() {
    let params = router.getParams() as Record<string, Object>;
    this.isEdit = params.isEdit as boolean;
    GlobalContext.getContext().setObject('FirstInTo', false);
    this.initializeData();
  }

  /**
   * Contact information change.
   *
   * @param key Key of the text information.
   * @param value Changed Data.
   */
  contactInfoChange(key: Resource, value: string) {
    let context = getContext(this) as AppContext.UIAbilityContext;
    let contactKey = context.resourceManager.getStringSync(key);
    switch (contactKey) {
      case CommonConstants.CONTACTS_DETAIL_NAME:
        this.name = value;
        break;
      case CommonConstants.CONTACTS_DETAIL_ADDRESS:
        this.address = value;
        break;
      case CommonConstants.CONTACTS_DETAIL_TEL:
        this.telephony = value;
        break;
      case CommonConstants.CONTACTS_DETAIL_EMAIL:
        this.email = value;
        break;
      case CommonConstants.CONTACTS_DETAIL_REMARKS:
        this.remarks = value;
        break;
      default:
        break;
    }
  }

  /**
   * Initialize edit page data.
   */
  initializeData(): void {
    // Check whether the page is an editing page.
    if (router.getParams() && this.isEdit) {
      let params = router.getParams() as Record<string, Object>;
      this.name = params.name as string;
      this.address = params.address as string;
      this.telephony = params.telephony as string;
      this.email = params.email as string;
      this.remarks = params.remarks as string;
    }
  }

  build() {
    Column() {
      Row() {
        this.NavigationTitle()
      }
      .width(CommonConstants.PERCENTAGE_MAX)
      .height($r('app.float.detail_navigation_height'))
      .backgroundColor($r('app.color.detail_page_background'))

      Column() {
        Column() {
          Image($r('app.media.ic_head_portrait'))
            .width($r('app.float.head_portrait_size'))
            .height($r('app.float.head_portrait_size'))
            .objectFit(ImageFit.Contain)
            .margin({
              bottom: $r('app.float.head_portrait_bottom'),
              top: $r('app.float.head_portrait_top')
            })
          if (!this.isEdit) {
            Text($r('app.string.edit_save_to_text'))
              .fontSize($r('app.float.edit_subtitle_size'))
              .fontWeight(FontWeight.Medium)
              .margin({
                bottom: $r('app.float.edit_save_margin_bottom')
              })
          }
          this.Item($r('app.string.edit_item_name'), $r('app.media.ic_name'), this.name)
          this.Item($r('app.string.edit_item_address'), $r('app.media.ic_address'), this.address)
          this.Item($r('app.string.edit_item_phone'), $r('app.media.ic_phone'), this.telephony)
          this.Item($r('app.string.edit_item_email'), $r('app.media.ic_email'), this.email)
          this.Item($r('app.string.edit_item_note'), $r('app.media.ic_note'), this.remarks)
        }
      }
      .layoutWeight(CommonConstants.WEIGHT)
    }
    .width(CommonConstants.PERCENTAGE_MAX)
    .height(CommonConstants.PERCENTAGE_MAX)
    .backgroundColor($r('app.color.detail_page_background'))
  }

  @Builder
  NavigationTitle() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_close'))
            .width($r('app.float.edit_icon_size'))
            .height($r('app.float.edit_icon_size'))
            .margin({ right: $r('app.float.close_icon_margin') })
            .onClick(() => {
              let url = this.isEdit ? CommonConstants.PAGE_DETAIL_URL : CommonConstants.LIST_PAGE_URL;
              this.editPageViewModel.commonRouter(url, this.name);
            })
          Text(this.isEdit ? $r('app.string.edit_title') : $r('app.string.add_contacts_text'))
            .width(CommonConstants.PERCENTAGE_MAX)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.navigation_title'))
            .fontSize($r('app.float.detail_navigation_title'))
            .focusable(true)
        }
        .layoutWeight(CommonConstants.WEIGHT)

        Row() {
          Image($r('app.media.ic_save'))
            .width($r('app.float.edit_icon_size'))
            .height($r('app.float.edit_icon_size'))
        }
        .layoutWeight(CommonConstants.WEIGHT)
        .justifyContent(FlexAlign.End)
        .onClick(() => {
          this.editPageViewModel.saveInfo(
            new ContactData(this.name, this.address, this.telephony, this.email, this.remarks)
          );
        })
      }
      .margin({
        right: $r('app.float.image_spacing_margin'),
        left: $r('app.float.image_spacing_margin')
      })
    }
  }

  @Builder
  Item(key: Resource, icon: Resource, content: string) {
    Row() {
      Image(icon)
        .objectFit(ImageFit.Contain)
        .height($r('app.float.item_icon_size'))
        .width($r('app.float.item_icon_size'))
        .margin({ right: $r('app.float.item_icon_margin') })
      Text(key)
        .fontSize($r('app.float.item_font_size'))
        .fontColor($r('app.color.font_color'))
        .fontWeight(FontWeight.Regular)
      TextInput({ text: content })
        .type(this.getInputType(key))
        .maxLength(this.getMaxLength(key))
        .width(CommonConstants.EDIT_INPUT_WIDTH)
        .margin({ right: $r('app.float.edit_input_margin') })
        .backgroundColor(Color.White)
        .fontSize($r('app.float.item_font_size'))
        .fontWeight(FontWeight.Regular)
        .enabled(this.textInputContext.resourceManager.getStringSync(key) === CommonConstants.CONTACTS_DETAIL_NAME
          && this.isEdit ? false : true)
        .onChange((value) => {
          this.contactInfoChange(key, value);
        })
    }
    .padding({
      top: $r('app.float.edit_item_padding_top'),
      bottom: $r('app.float.edit_item_padding_bottom'),
      left: $r('app.float.edit_item_padding_left'),
      right: $r('app.float.edit_item_padding_right')
    })
    .margin({
      bottom: $r('app.float.edit_item_margin'),
      top: $r('app.float.edit_item_margin')
    })
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.edit_item_border_radius'))
    .width(CommonConstants.PAGE_TITLE_WIDTH)
  }

  getInputType(key: Resource): InputType {
    switch (this.textInputContext.resourceManager.getStringSync(key)) {
      case CommonConstants.CONTACTS_DETAIL_TEL:
        return InputType.PhoneNumber;
      case CommonConstants.CONTACTS_DETAIL_EMAIL:
        return InputType.Email;
      default:
        return InputType.Normal;
    }
  }

  getMaxLength(key: Resource): number {
    switch (this.textInputContext.resourceManager.getStringSync(key)) {
      case CommonConstants.CONTACTS_DETAIL_NAME:
        return CommonConstants.CONTACTS_NAME_MAX_LENGTH;
      case CommonConstants.CONTACTS_DETAIL_TEL:
        return CommonConstants.CONTACTS_TEL_MAX_LENGTH;
      default:
        return CommonConstants.CONTACTS_DETAIL_MAX;
    }
  }
}
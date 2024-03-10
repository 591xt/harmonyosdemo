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
import deviceManager from '@ohos.distributedDeviceManager';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../common/constants/CommonConstants';
import DeviceListDialogComponent from '../view/DeviceDialog';
import PageViewModel from '../viewmodel/PageViewModel';
import Logger from '../common/util/Logger';
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { RemoteDeviceModel } from '../viewmodel/RemoteDeviceModel';
import { ListPageViewModel } from '../viewmodel/ListPageViewModel';
import { ListAreaComponent } from '../view/ListAreaComponent';
import { GlobalContext } from '../common/util/GlobalContext';
import { ListItemData } from '../viewmodel/ListItemData';

const TAG: string = 'ListPage';

@Entry
@Component
struct ListPage {
  @StorageLink('deviceList') deviceList: Array<deviceManager.DeviceBasicInfo> = [];
  @StorageLink('contactData') contactData: Array<ListItemData> = [];
  @StorageLink('isContactsEmpty') isContactsEmpty: boolean = true;
  @StorageLink('contactsNumber') contactsNumber: number = 0;
  @State selectedIndex: number | undefined = 0;
  @State customPopup: boolean = false;
  private listPageViewModel: ListPageViewModel = new ListPageViewModel();
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel();
  private dialogController: CustomDialogController | null = null;
  contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;
  onSelectedIndexChange = async (index: number | undefined) => {
    Logger.info(TAG, `selectedIndexChange`);
    this.selectedIndex = index;
    if (this.selectedIndex === 0) {
      Logger.info(TAG, `stop ability`);
      this.listPageViewModel.startAbilityCallBack(CommonConstants.EXIT);
      this.deviceList = [];
      if (this.dialogController !== null) {
        this.dialogController.close();
      }
      return;
    }
    this.selectDevice();
  }

  selectDevice(): void {
    if (this.selectedIndex !== undefined && (this.remoteDeviceModel === null ||
      this.remoteDeviceModel.discoverList.length <= 0)) {
      Logger.info(TAG, `continue unauthed device: ${JSON.stringify(this.deviceList)}`);
      this.listPageViewModel.startAbility(this.deviceList[this.selectedIndex].networkId);
      this.clearSelectState();
      return;
    }
    Logger.info(TAG, `start ability, needAuth：`);
    if (this.selectedIndex !== undefined) {
      this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
        Logger.info(TAG, `auth and online finished`);
        if (this.remoteDeviceModel !== null
          && this.remoteDeviceModel.deviceList !== null
          && this.selectedIndex !== undefined) {
          for (let i = 0; i < this.remoteDeviceModel.deviceList!.length; i++) {
            if (this.remoteDeviceModel.deviceList![i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
              this.listPageViewModel.startAbility(this.remoteDeviceModel.deviceList![i].networkId);
            }
          }
        }
      })
    }
    this.clearSelectState();
  }

  clearSelectState(): void {
    this.deviceList = [];
    if (this.dialogController !== null) {
      this.dialogController.close();
    }
    Logger.info(TAG, `cancelDialog`);
    if (this.remoteDeviceModel === undefined) {
      return;
    }
    this.remoteDeviceModel.unregisterDeviceListCallback();
  }

  onPageShow() {
    // Access the listPage page to obtain the list data.
    this.getAllData();
    router.clear();
  }

  aboutToAppear() {
    GlobalContext.getContext().setObject('FirstInTo', true);
    setTimeout(() => {
      this.contactsDataBase.subscriptionKvStore(() => {
        // When the remote data changes, the page data is updated.
        this.getAllData();
      });
    }, 50);
  }

  /**
   * This interface is used to obtain all data on the contact home page.
   */
  getAllData(): void {
    setTimeout(() => {
      this.contactsDataBase.getEntries(CommonConstants.CONTACTS_DATABASE_KEY, (
        err: BusinessError,
        entries: distributedKVStore.Entry[]) => {
        Logger.info(TAG, `getAllData entries: ${JSON.stringify(entries)}`);
        if (err) {
          Logger.error(`Fail to get Entries, code message is ${JSON.stringify(err)}`);
          return;
        }
        this.contactsNumber = entries.length;
        this.isContactsEmpty = this.contactsNumber > 0 ? false : true;
        this.contactData = PageViewModel.getData(entries);
      }
      );
    }, 50);
  }

  /**
   * In the dialog box that is displayed, select a device from the list and verify the device for the first time.
   * After the verification is successful, start the remote device application for the second time.
   */
  showDialogInfo(): void {
    this.deviceList = [];
    // Register a listening callback.
    // A dialog box is displayed when a device is discovered or an authenticated device is found.
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      this.deviceList = [];
      Logger.info(TAG, `registerDeviceListCallback, callback entered`);
      let context: common.UIAbilityContext | undefined = AppStorage.get('UIAbilityContext');
      if (context !== undefined) {
        this.deviceList.push({
          deviceId: '0',
          deviceName: CommonConstants.LOCALHOST_NAME,
          deviceType: '0',
          networkId: ''
        })
      }
      let deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ?
      this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList;
      if (deviceTempList !== null) {
        for (let i = 0; i < deviceTempList!.length; i++) {
          this.deviceList.push({
            deviceId: deviceTempList![i].deviceId,
            deviceName: deviceTempList![i].deviceName,
            deviceType: deviceTempList![i].deviceType,
            networkId: deviceTempList![i].networkId
          });
          AppStorage.set('deviceList', this.deviceList);
        }
      }
    })
    if (this.dialogController === null) {
      this.dialogController = new CustomDialogController({
        builder: DeviceListDialogComponent({
          selectedIndex: this.selectedIndex,
          onSelectedIndexChange: this.onSelectedIndexChange
        }),
        cancel: () => {
          this.clearSelectState();
        },
        autoCancel: true
      })
    }
    if (this.dialogController !== null) {
      this.dialogController.open();
    }
  }

  build() {
    Column() {
      this.NavigationMenus()
      this.ListHeader()
      this.List()
    }
    .padding({
      left: $r('app.float.search_padding_horizontal'),
      right: $r('app.float.search_padding_horizontal')
    })
    .width(CommonConstants.PERCENTAGE_MAX)
    .backgroundColor($r('app.color.theme_background'))
  }

  @Builder
  NavigationMenus() {
    Row() {
      Image($r('app.media.ic_add'))
        .width($r('app.float.empty_view_size'))
        .height($r('app.float.empty_view_size'))
        .margin({ right: $r('app.float.image_spacing_margin') })
        .onClick(() => {
          this.listPageViewModel.redirectAddPage();
        })
      Image($r('app.media.ic_more'))
        .width($r('app.float.empty_view_size'))
        .height($r('app.float.empty_view_size'))
        .margin({ right: $r('app.float.image_spacing_margin') })
        .bindPopup(this.customPopup, {
          builder: this.popupBuilder,
          placement: Placement.Bottom,
          popupColor: Color.White,
          enableArrow: false
        })
        .onClick(() => {
          this.customPopup = !this.customPopup;
        })
    }
    .height($r('app.float.detail_navigation_height'))
    .width(CommonConstants.PERCENTAGE_MAX)
    .justifyContent(FlexAlign.End)
  }

  @Builder
  ListHeader() {
    Column() {
      Text($r('app.string.page_title'))
        .textAlign(TextAlign.Start)
        .width(CommonConstants.PERCENTAGE_MAX)
        .fontColor($r('app.color.navigation_title'))
        .fontSize($r('app.float.title_size'))
        .focusable(true)
      if (!this.isContactsEmpty) {
        Row() {
          Text(this.contactsNumber.toString())
            .margin({ top: $r('app.float.contacts_num_margin_top') })
            .fontSize($r('app.float.contacts_num_size'))
            .fontColor($r('app.color.contacts_num'))
          Text($r('app.string.contacts_num_template'))
            .margin({ top: $r('app.float.contacts_num_margin_top') })
            .fontSize($r('app.float.contacts_num_size'))
            .fontColor($r('app.color.contacts_num'))
        }
        .width(CommonConstants.PERCENTAGE_MAX)
      }
    }
    .margin({
      top: $r('app.float.navigation_margin_top'),
      left: $r('app.float.navigation_margin_left'),
      right: $r('app.float.navigation_margin_right'),
      bottom: $r('app.float.navigation_margin_bottom')
    })
  }

  @Builder
  List() {
    if (this.isContactsEmpty) {
      // There is no data in the database.
      this.buildEmptyView();
    } else {
      // The database has data.
      this.buildDataView();
    }
  }

  @Builder
  buildEmptyView() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width($r('app.float.contact_picture_size'))
        .height($r('app.float.contact_picture_size'))
        .margin({ bottom: $r('app.float.empty_view_margin') })
      Text($r('app.string.contacts_empty'))
        .fontSize($r('app.float.contacts_empty_size'))
        .fontColor($r('app.color.empty_font_color'))
    }
    .height(CommonConstants.PERCENTAGE_MAX)
    .width(CommonConstants.PERCENTAGE_MAX)
    .justifyContent(FlexAlign.Start)
    .padding({
      top: CommonConstants.CONTACTS_EMPTY_TOP
    })
  }

  @Builder
  buildDataView() {
    Column() {
      Search({
        placeholder: Object($r('app.string.search_contact'))
      })
        .width(CommonConstants.PERCENTAGE_MAX)
        .height($r('app.float.search_height'))
        .border({ radius: $r('app.float.search_radius') })
        .placeholderColor($r('app.color.empty_font_color'))
        .placeholderFont({
          size: $r('app.float.search_text_size'),
          weight: CommonConstants.SEARCH_FONT_WEIGHT,
          family: CommonConstants.SEARCH_FONT_FAMILY,
          style: FontStyle.Normal
        })
        .textFont({ size: $r('app.float.search_text_size') })
        .margin({ bottom: $r('app.float.search_margin_bottom') })
        .padding({
          left: $r('app.float.search_padding'),
          right: $r('app.float.search_padding')
        })
      ListAreaComponent({ contactData: $contactData })
        .height(CommonConstants.CONTACTS_LIST_HEIGHT)
    }
    .backgroundColor($r('app.color.theme_background'))
    .width(CommonConstants.PERCENTAGE_MAX)
  }

  @Builder
  popupBuilder() {
    Column() {
      Text($r('app.string.delete_batch'))
        .fontSize($r('app.float.popup_font_size'))
        .padding({
          top: $r('app.float.delete_padding_vertical'),
          bottom: $r('app.float.delete_padding_vertical'),
          left: $r('app.float.delete_padding_left')
        })
        .onClick(() => {
          this.listPageViewModel.redirectDeletePage();
        })
      Divider()
        .height($r('app.float.divider_height'))
        .backgroundColor($r('app.color.list_divider'))
        .margin({
          left: $r('app.float.delete_padding_left'),
          right: $r('app.float.delete_padding_left')
        })
      Text($r('app.string.connection_device'))
        .fontSize($r('app.float.popup_font_size'))
        .padding({
          top: $r('app.float.delete_padding_vertical'),
          bottom: $r('app.float.delete_padding_vertical'),
          left: $r('app.float.delete_padding_left')
        })
        .onClick(() => {
          this.customPopup = !this.customPopup;
          Logger.info('Index', 'onContinueAbilityClick execute');
          this.showDialogInfo();
        })
    }
    .width($r('app.float.popup_width'))
    .height($r('app.float.popup_height'))
    .alignItems(HorizontalAlign.Start)
  }
}
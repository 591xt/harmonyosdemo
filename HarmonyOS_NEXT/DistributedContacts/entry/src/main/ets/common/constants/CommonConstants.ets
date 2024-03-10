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

/**
 * Common constants for all features.
 */
export default class CommonConstants {
  /**
   * Search font weight.
   */
  static readonly SEARCH_FONT_WEIGHT: number = 10;

  /**
   * The font family of search component.
   */
  static readonly SEARCH_FONT_FAMILY: string = 'serif';

  /**
   * The layout weight of the list title.
   */
  static readonly TITLE_LAYOUT_WEIGHT: number = 1;

  /**
   * The max lines of the list title.
   */
  static readonly TITLE_MAX_LINES: number = 1;

  /**
   * Set component layout weight.
   */
  static readonly WEIGHT: number = 1;

  /**
   *  The contacts detail page url.
   */
  static readonly PAGE_DETAIL_URL: string = 'pages/DetailPage';

  /**
   * The contacts editing page url.
   */
  static readonly ADD_EDIT_URL: string = 'pages/EditPage';

  /**
   * The contacts list page url.
   */
  static readonly LIST_PAGE_URL: string = 'pages/ListPage';

  /**
   * The contacts delete page url.
   */
  static readonly DELETE_PAGE_URL: string = 'pages/DeletePage';

  /**
   * The key to transfer parameters when replace pages.
   */
  static readonly KEY_PARAM_DATA: string = 'data';

  /**
   * The maximum component width.
   */
  static readonly PERCENTAGE_MAX: string = '100%';

  /**
   * Eighty percent assembly width.
   */
  static readonly PERCENTAGE_HEIGHT_MAX: string = '80%';

  /**
   * Delete page title width.
   */
  static readonly PAGE_TITLE_WIDTH: string = '90%';

  /**
   * Edit the width of the input box on the page.
   */
  static readonly EDIT_INPUT_WIDTH: string = '80%';

  /**
   * The contacts details page components width.
   */
  static readonly DETAIL_ITEM_WIDTH: string = '70%';

  /**
   * Height of the address book list.
   */
  static readonly CONTACTS_LIST_HEIGHT: string = '90%';

  /**
   * The width of the bottom component.
   */
  static readonly BOTTOM_COMPONENT_WIDTH: string = '50%';

  /**
   * The contacts details page top height.
   */
  static readonly DETAIL_TOP_HEIGHT: string = '30%';

  /**
   * The percentage of list component.
   */
  static readonly LIST_WIDTH_PERCENT: string = '93.3%';

  /**
   * The contacts list divider left margin.
   */
  static readonly CONTACTS_LIST_DIVIDER: string = '16%';

  /**
   * The contacts list divider left margin.
   */
  static readonly CONTACTS_EMPTY_TOP: string = '17.8%';

  /**
   * Contact database key.
   */
  static readonly CONTACTS_DATABASE_KEY: string = 'contactsKey';

  /**
   * The contact name.
   */
  static readonly CONTACTS_DETAIL_NAME: string = '姓名';

  /**
   * The contact address.
   */
  static readonly CONTACTS_DETAIL_ADDRESS: string = '地址';

  /**
   * The contact telephony.
   */
  static readonly CONTACTS_DETAIL_TEL: string = '手机';

  /**
   * The contact email.
   */
  static readonly CONTACTS_DETAIL_EMAIL: string = '邮箱';

  /**
   * The contact remarks.
   */
  static readonly CONTACTS_DETAIL_REMARKS: string = '备注';

  /**
   * The message prompt component duration.
   */
  static readonly PROMPT_DURATION: number = 2000;

  /**
   * Address book database unique identifier.
   */
  static readonly DB_STORE_ID: string = 'DatabaseStoreId';

  /**
   * Ability name.
   */
  static readonly ABILITY_NAME: string = 'EntryAbility';

  /**
   * Detail page id.
   */
  static readonly DETAIL_PAGE_ID: string = 'detailId';

  /**
   * Delete page id.
   */
  static readonly DELETE_PAGE_ID: string = 'deleteId';

  /**
   * Phone components id.
   */
  static readonly PHONE_COMPONENTS_ID: number = 1;

  /**
   * Email components id.
   */
  static readonly Email_COMPONENTS_ID: number = 2;

  /**
   * Note components id.
   */
  static readonly Note_COMPONENTS_ID: number = 3;

  /**
   * Device list group.
   */
  static readonly DEVICE_GROUP: string = 'deviceGroup';

  /**
   * Even column.
   */
  static readonly EVEN_COLUMN: number = 2;

  /**
   * Indicates whether to edit the page.
   */
  static readonly IS_EDIT: string = 'isEdit';

  /**
   * Key of details page information.
   */
  static readonly DETAIL_INFO_KEY: string = 'key';

  /**
   * Monitors distributed database changes.
   */
  static readonly DATA_CHANGE: string = 'dataChange';

  /**
   * Start ability callback.
   */
  static readonly EXIT: string = 'exit';

  /**
   * Start ability callback id.
   */
  static readonly SUBSCRIBE_ID: number = 100;

  /**
   * The mode of start device discovery info.
   */
  static readonly INFO_MODE: number = 0xAA;

  /**
   * The frequency of start device discovery info.
   */
  static readonly INFO_FREQ: number = 2;

  /**
   * Discover device list.
   */
  static readonly DISCOVER_DEVICE_LIST: string = 'discoverDeviceList';

  /**
   * Zero.
   */
  static readonly ZERO: string = '0';

  /**
   * One.
   */
  static readonly ONE: number = 1;

  /**
   * Trusted device list.
   */
  static readonly TRUSTED_DEVICE_LIST: string = 'trustedDeviceList';

  /**
   * Subscribe ID range.
   */
  static readonly SUBSCRIBE_ID_RANGE: number = 65536;

  /**
   * Auth type.
   */
  static readonly AUTH_TYPE: number = 1;

  /**
   * Subscribe mode.
   */
  static readonly SUBSCRIBE_MODE: number = 0xAA;

  /**
   * Subscribe medium.
   */
  static readonly SUBSCRIBE_MEDIUM: number = 0;

  /**
   * Subscribe freq.
   */
  static readonly SUBSCRIBE_FREQ: number = 2;

  /**
   * Subscribe capability.
   */
  static readonly SUBSCRIBE_CAPABILITY: number = 0;

  /**
   * Font weight.
   */
  static readonly FONT_WEIGHT_500: number = 500;

  /**
   * Invalid Index.
   */
  static readonly INVALID_INDEX: number = -1;


  /**
   * One hundred percent.
   */
  static readonly FULL_PERCENT: string = '100%';

  /**
   * Number one.
   */
  static readonly NUMBER_ONE: number = 1;

  /**
   * Device name width.
   */
  static readonly DEVICE_NAME_WIDTH: string = '78%';

  /**
   * Select icon width.
   */
  static readonly SELECT_ICON_WIDTH: string = '8%';

  /**
   * Localhost name.
   */
  static readonly LOCALHOST_NAME: string = 'Local Host';

  /**
   * Entry ability.
   */
  static readonly ENTRY_ABILITY: string = 'EntryAbility';

  /**
   * Ability name.
   */
  static readonly BUNDLE_NAME: string = 'com.example.distributedcontacts';

  /**
   * App name.
   */
  static readonly APP_NAME: string = 'Distributed Contacts';

  /**
   * Contacts name max length.
   */
  static readonly CONTACTS_NAME_MAX_LENGTH: number = 10;

  /**
   * Contacts tel max length.
   */
  static readonly CONTACTS_TEL_MAX_LENGTH: number = 11;

  /**
   * Contacts detail input box max length.
   */
  static readonly CONTACTS_DETAIL_MAX: number = 20;
}
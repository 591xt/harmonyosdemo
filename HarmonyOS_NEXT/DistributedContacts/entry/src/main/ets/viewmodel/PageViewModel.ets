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
import distributedKVStore from '@ohos.data.distributedKVStore';
import { BusinessError } from '@ohos.base';
import Logger from '../common/util/Logger';
import CheckEmptyUtils from '../common/util/CheckEmptyUtils';
import CommonConstants from '../common/constants/CommonConstants';
import { ListItemData } from './ListItemData';

const TAG: string = 'PageViewModel';

/**
 * Interface for batch delete page and contacts Home page.
 */
export class PageViewModel {
  /**
   * Processes data obtained from distributed data services.
   *
   * @param contactData contact data queried from the database.
   */
  getData(contactData: distributedKVStore.Entry[]): Array<ListItemData> {
    Logger.info(TAG, `getData contactData: ${JSON.stringify(contactData)}`);
    let listItems: Array<ListItemData> = [];
    if (CheckEmptyUtils.isEmptyArr(contactData)) {
      Logger.info(TAG, '[PageViewModel][getData] contactData is empty.');
      return listItems;
    }
    for (let i = 0; i < contactData.length; i++) {
      let itemInfo: ListItemData = new ListItemData();
      itemInfo.photo = (i % CommonConstants.EVEN_COLUMN === 1) ? $r('app.media.ic_men') : $r('app.media.ic_women');
      itemInfo.name = JSON.parse(contactData[i].value.value as string).name;
      itemInfo.id = i;
      listItems.push(itemInfo);
    }
    return listItems;
  }

  /**
   * Obtains the quantity of a batch.
   *
   * @param list Contact list data.
   */
  getSelectCount(list: Array<ListItemData>): number {
    if (CheckEmptyUtils.isEmptyArr(list)) {
      Logger.info(TAG, '[PageViewModel][getSelectCount] list is empty.');
      Logger.error(TAG, `CheckEmptyUtils.isEmptyArr(list)： ${JSON.stringify(CheckEmptyUtils.isEmptyArr(list))}`);
      return 0;
    }
    let result = list.filter((item) => {
      return item.checked;
    });
    Logger.error(TAG, `result.length： ${result.length}`);
    return result.length;
  }

  /**
   * Select all data.
   */
  getSelectAll(checkList: Array<ListItemData>): Array<ListItemData> {
    checkList.forEach((item: ListItemData) => {
      item.checked = true;
    });
    return checkList;
  }

  /**
   * Do not select all data.
   */
  getUnSelectAll(checkList: Array<ListItemData>): Array<ListItemData> {
    checkList.forEach((item: ListItemData) => {
      item.checked = false;
    });
    return checkList;
  }

  /**
   * redirect detail page.
   *
   * @param item List Information.
   */
  redirectDetailPage(item: ListItemData): void {
    let contactsKey = CommonConstants.CONTACTS_DATABASE_KEY + item.name;
    router.pushUrl({
      url: CommonConstants.PAGE_DETAIL_URL,
      params: {
        key: contactsKey
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `pushUrl failed, error message is ${JSON.stringify(err)}`);
    });
  }
}

let pageViewModel = new PageViewModel();

export default pageViewModel as PageViewModel;
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

import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../common/constants/CommonConstants';
import ContactData from './ContactData';
import Logger from '../common/util/Logger'
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { GlobalContext } from '../common/util/GlobalContext';

export class EditPageViewModel {
  contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;

  /**
   * Public routing method.
   *
   * @param url Indicates the route address.
   */
  commonRouter(url: string, name: string): void {
    let contactsKey = CommonConstants.CONTACTS_DATABASE_KEY + name;
    router.pushUrl({
      url: url,
      params: {
        key: contactsKey
      }
    }).catch((err: BusinessError) => {
      Logger.error(`pushUrl failed, code message is ${JSON.stringify(err)}`);
    });
  }

  /**
   * Save contact information.
   */
  saveInfo(contactData: ContactData): void {
    if (contactData.name !== '') {
      let contactsKey = CommonConstants.CONTACTS_DATABASE_KEY + contactData.name;
      // Save the contact information.
      this.contactsDataBase.save(contactsKey, JSON.stringify(contactData));
      router.replaceUrl({
        url: CommonConstants.PAGE_DETAIL_URL,
        params: { key: contactsKey }
      }).catch((err: BusinessError) => {
        Logger.error(`pushUrl failed, code message is ${JSON.stringify(err)}`);
      });
    } else {
      promptAction.showToast({
        message: $r('app.string.contact_name'),
        duration: CommonConstants.PROMPT_DURATION
      });
    }
  }
}
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
import Logger from '../common/util/Logger';
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { GlobalContext } from '../common/util/GlobalContext';

export class DetailPageViewModel {
  contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;

  /**
   * Button for canceling the deletion dialog box.
   */
  cancelDialog(): void {
    promptAction.showToast({
      message: $r('app.string.delete_cancel_text'),
      duration: CommonConstants.PROMPT_DURATION
    });
  }

  /**
   * Delete contact button.
   */
  deleteContactButton(name: string): void {
    let contactsKey = CommonConstants.CONTACTS_DATABASE_KEY + name;
    try {
      // This interface is used to delete the information about a specified contact.
      this.contactsDataBase.delete(contactsKey, () => {
        promptAction.showToast({
          message: $r('app.string.prompt_message_deleted'),
          duration: CommonConstants.PROMPT_DURATION
        });
        router.pushUrl({
          url: CommonConstants.LIST_PAGE_URL
        }).catch((err: BusinessError) => {
          Logger.error(`pushUrl failed, code message is ${JSON.stringify(err)}`);
        });
      });
    } catch (err) {
      Logger.error(`An unexpected error occurred, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Button for redirecting to the details page.
   */
  redirectEditPage(name: string, address: string, telephony: string, email: string, remarks: string): void {
    let routerParameter: router.RouterOptions = {
      url: CommonConstants.ADD_EDIT_URL,
      params: {
        isEdit: true,
        name,
        address,
        telephony,
        email,
        remarks
      }
    }
    if (GlobalContext.getContext().getObject('FirstInTo')) {
      router.pushUrl(routerParameter).catch((err: BusinessError) => {
        Logger.error(`PushUrl failed, code message is ${JSON.stringify(err)}`);
      });
    } else {
      router.replaceUrl(routerParameter).catch((err: BusinessError) => {
        Logger.error(`ReplaceUrl failed, code message is ${JSON.stringify(err)}`);
      });
    }
  }

  /**
   * Redirect list page.
   */
  redirectListPage(): void {
    router.pushUrl({
      url: CommonConstants.LIST_PAGE_URL
    }).catch((err: BusinessError) => {
      Logger.error(`pushUrl failed, error message is ${JSON.stringify(err)}`);
    });
  }
}
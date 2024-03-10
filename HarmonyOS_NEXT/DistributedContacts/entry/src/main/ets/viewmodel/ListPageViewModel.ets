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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../common/constants/CommonConstants';
import Logger from '../common/util/Logger';
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { GlobalContext } from '../common/util/GlobalContext';

const TAG: string = 'ListPageViewModel';

export class ListPageViewModel {
  startAbilityCallBack: (key: string) => void = () => {
  };
  contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;

  async startAbility(deviceId: string | undefined) {
    Logger.info(TAG, `startAbility deviceId: ${deviceId}`);
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      bundleName: CommonConstants.BUNDLE_NAME,
      abilityName: CommonConstants.ENTRY_ABILITY,
      deviceId: deviceId
    }
    context.startAbility(want).then((data) => {
      Logger.info(TAG, `start ability finished: ${JSON.stringify(data)}`);
      this.startAbilityCallBack(CommonConstants.DATA_CHANGE);
    })
  }

  /**
   * Button for redirecting to the add page.
   */
  redirectAddPage(): void {
    router.pushUrl({
      url: CommonConstants.ADD_EDIT_URL,
      params: {
        isEdit: false
      }
    }).catch((err: BusinessError) => {
      Logger.error(`pushUrl failed, code message is ${JSON.stringify(err)}`);
    });
  }

  /**
   * Button for redirecting to the delete page.
   */
  redirectDeletePage(): void {
    router.pushUrl({
      url: CommonConstants.DELETE_PAGE_URL
    }).catch((err: BusinessError) => {
      Logger.error(`pushUrl failed, code message is ${JSON.stringify(err)}`);
    });
  }
}

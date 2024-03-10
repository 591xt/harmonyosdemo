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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';
import Logger from '../common/util/Logger';
import { ContactsDataBase } from '../common/database/ContactsDataBase';
import { GlobalContext } from '../common/util/GlobalContext';

const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.permissions();
    AppStorage.setOrCreate('UIAbilityContext', this.context);
    GlobalContext.getContext().setObject('FirstInTo', true);
    GlobalContext.getContext().setObject('entryContext', this.context);
    GlobalContext.getContext().setObject('contactsDataBase', new ContactsDataBase());
    Logger.info(TAG, `Ability onCreate`);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.permissions();
    AppStorage.setOrCreate('UIAbilityContext', this.context);
    GlobalContext.getContext().setObject('FirstInTo', true);
    GlobalContext.getContext().setObject('entryContext', this.context);
    GlobalContext.getContext().setObject('contactsDataBase', new ContactsDataBase());
    Logger.info(TAG, `Ability onNewWant`);
  }

  onDestroy(): void | Promise<void> {
    Logger.info(TAG, 'onDestroy execute');
    let contactsDataBase = GlobalContext.getContext().getObject('contactsDataBase') as ContactsDataBase;
    contactsDataBase.removeDataChangeListener();
    contactsDataBase.closeKVStore();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability.
    hilog.isLoggable(0x0000, TAG, hilog.LogLevel.INFO);
    Logger.info(TAG, `Ability onWindowStageCreate`);
    windowStage.loadContent('pages/ListPage', (err: BusinessError, data) => {
      if (err.code) {
        hilog.isLoggable(0x0000, TAG, hilog.LogLevel.ERROR);
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      hilog.isLoggable(0x0000, TAG, hilog.LogLevel.INFO);
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
    });
  }

  /**
   * Apply for the permission to exchange data between different devices.
   */
  permissions(): void {
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(this.context, ['ohos.permission.DISTRIBUTED_DATASYNC']).then((data) => {
        Logger.info(TAG, `Data permissions:${data.permissions}`);
      });
    } catch (err) {
      Logger.info(TAG, `Catch err: ${err}`);
    }
  }
}
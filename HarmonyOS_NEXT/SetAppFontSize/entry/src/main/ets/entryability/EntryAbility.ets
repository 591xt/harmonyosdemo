/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility'
import CommonConstants from '../common/constants/CommonConstants';
import Logger from '../common/utils/Logger';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import window from '@ohos.window';
import base from '@ohos.base';
import dataPreferences from '@ohos.data.preferences';

const TAG = '[entryAbility]';
const KEY_APP_FONT_SIZE = 'appFontSize';

/**
 * Lift cycle management of Ability.
 */
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'onCreate');
    // 设置字体默认大小
    try {
      let options: dataPreferences.Options =  { name: 'myStore' };
      let promise = dataPreferences.getPreferences(this.context, options);
      promise.then((object: dataPreferences.Preferences) => {
        object.has(KEY_APP_FONT_SIZE).then(async (isExist: boolean) => {
          Logger.info(TAG, 'preferences has changeFontSize is ' + isExist);
          if (!isExist) {
            await object?.put(KEY_APP_FONT_SIZE, CommonConstants.SET_SIZE_NORMAL);
            await object?.flush();
          }
        }).catch((err: Error) => {
          Logger.error(TAG, 'Has the value failed with err: ' + err);
        });
        console.info("Succeeded in getting preferences.");
      }).catch((err: base.BusinessError) => {
        console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
      })
    } catch (err) {
      console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
    }
  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'onWindowStageCreate');

    windowStage.loadContent('pages/HomePage', (err, data) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'onBackground');
  }
};

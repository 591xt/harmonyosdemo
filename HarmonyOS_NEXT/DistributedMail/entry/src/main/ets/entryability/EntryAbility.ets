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

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import distributedDataObject from '@ohos.data.distributedDataObject';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import UIAbility from '@ohos.app.ability.UIAbility';
import Logger from '../common/utils/Logger';
import { CommonConstants } from '../common/constants/CommonConstants';
import { AppendixBean } from '../viewmodel/AppendixItem';
import { MailInfo } from '../viewmodel/MailInfo';

export default class EntryAbility extends UIAbility {
  private localObject: distributedDataObject.DataObject | undefined = undefined;
  private targetDeviceId: string | undefined = undefined;
  private changeCall: (sessionId: string, fields: Array<string>) => void = (sessionId: string, fields: Array<string>) => {
    if (fields != null && fields != undefined && this.localObject != undefined) {
      for (let index: number = 0; index < fields.length; index++) {
        if (fields[index] === 'recipient') {
          AppStorage.setOrCreate<string>('recipient', this.localObject['recipient'] as string);
        } else if (fields[index] === 'sender') {
          AppStorage.setOrCreate<string>('sender', this.localObject['sender'] as string);
        } else if (fields[index] === 'subject') {
          AppStorage.setOrCreate<string>('subject', this.localObject['subject'] as string);
        } else if (fields[index] === 'emailContent') {
          AppStorage.setOrCreate<string>('emailContent', this.localObject['emailContent'] as string);
        }
      }
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info('EntryAbility', 'Ability onCreate');
    this.restoringData(want, launchParam);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info('EntryAbility', 'Ability onNewWant');
    this.restoringData(want, launchParam);
  }

  async restoringData(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    this.checkPermissions();
    // Recovering migrated data from want.
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      // get user data from want params.
      AppStorage.setOrCreate<string>('isContinuation', CommonConstants.CAN_CONTINUATION);
      AppStorage.setOrCreate<Array<AppendixBean>>('appendix', JSON.parse(want.parameters?.appendix as string) as Array<AppendixBean>);
      let sessionId : string = want.parameters?.distributedSessionId as string;
      AppStorage.setOrCreate('sessionId', sessionId);
      if (!this.localObject) {
        let mailInfo: MailInfo = new MailInfo(undefined, undefined, undefined, undefined);
        this.localObject = distributedDataObject.create(this.context, mailInfo);
        this.localObject.on('change', this.changeCall)
      }
      if (sessionId && this.localObject) {
        await this.localObject.setSessionId(sessionId);
        AppStorage.setOrCreate('recipient', this.localObject['recipient']);
        AppStorage.setOrCreate('sender', this.localObject['sender']);
        AppStorage.setOrCreate('subject', this.localObject['subject']);
        AppStorage.setOrCreate('emailContent', this.localObject['emailContent']);
      }
      this.context.restoreWindowStage(new LocalStorage());
    }
  }

  onContinue(wantParam: Record<string, Object | undefined>): AbilityConstant.OnContinueResult {
    // The data to be migrated is stored in wantParam.
    wantParam.appendix = JSON.stringify(AppStorage.get<Array<AppendixBean>>('appendix'));
    try {
      let sessionId: string = AppStorage.get('sessionId') as string;
      if (!sessionId) {
        sessionId = distributedDataObject.genSessionId();
        AppStorage.setOrCreate('sessionId', sessionId);
      }
      if (this.localObject) {
        this.localObject.setSessionId(sessionId);
        this.localObject['recipient'] = AppStorage.get('recipient');
        this.localObject['sender'] = AppStorage.get('sender');
        this.localObject['subject'] = AppStorage.get('subject');
        this.localObject['emailContent'] = AppStorage.get('emailContent');
        this.targetDeviceId = wantParam.targetDevice as string;
        this.localObject.save(wantParam.targetDevice as string).then(() => {
          Logger.info('onContinue localObject save success');
        }).catch((err: BusinessError) => {
          Logger.error(`Failed to save. Code:${err.code},message:${err.message}`);
        });
      }
      wantParam.distributedSessionId = sessionId;
    } catch (error) {
      Logger.error('EntryAbility', 'distributedDataObject failed', `code ${(error as BusinessError).code}`)
    }
    return AbilityConstant.OnContinueResult.AGREE;
  }

  async checkPermissions(): Promise<void> {
    const permissions: Array<Permissions> = ["ohos.permission.DISTRIBUTED_DATASYNC"];
    const accessManager = abilityAccessCtrl.createAtManager();
    try {
      const bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
      const grantStatus = await accessManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, permissions[0]);

      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        accessManager.requestPermissionsFromUser(this.context, permissions)
      }
    } catch (err) {
      Logger.error('EntryAbility', 'checkPermissions', `Catch err: ${err}`);
      return;
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability.
    Logger.info('EntryAbility', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MailHomePage', (err, data) => {

      if (err.code) {
        Logger.error('EntryAbility', 'Failed to load the content, ', `Catch err: ${err}`);
        return;
      }
      Logger.info('EntryAbility', 'Succeeded in loading the content, ', `Data: ${data}`);
    });
    if (!this.localObject) {
      let mailInfo: MailInfo = new MailInfo(undefined, undefined, undefined, undefined);
      this.localObject = distributedDataObject.create(this.context, mailInfo);
    }
  }

  onWindowStageDestroy() {
    Logger.info('EntryAbility', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    Logger.info('EntryAbility', 'Ability onForeground');
  }

  onBackground() {
    Logger.info('EntryAbility', 'Ability onBackground');
  }

  async onDestroy() {
    Logger.info('EntryAbility', 'Ability onDestroy');
    if (this.localObject && this.targetDeviceId) {
      await this.localObject.save(this.targetDeviceId).then(() => {
        Logger.info('onDestroy localObject save success');
      }).catch((err: BusinessError) => {
        Logger.error(`Failed to save. Code:${err.code},message:${err.message}`);
      });
    }
  }
}

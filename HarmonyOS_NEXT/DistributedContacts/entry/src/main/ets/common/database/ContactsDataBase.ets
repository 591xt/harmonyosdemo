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
import common from '@ohos.app.ability.common';
import { AsyncCallback, BusinessError, Callback } from '@ohos.base';
import CommonConstants from '../constants/CommonConstants';
import Logger from '../util/Logger';
import { GlobalContext } from '../../common/util/GlobalContext';

const TAG: string = 'ContactsDataBase';

export class ContactsDataBase {
  private kvManager: distributedKVStore.KVManager | undefined = undefined;
  private kvStore: distributedKVStore.SingleKVStore | undefined = undefined;
  private context: common.UIAbilityContext;

  constructor() {
    this.context = GlobalContext.getContext().getObject('entryContext') as common.UIAbilityContext;
    this.createManager();
  }

  createManager(): void {
    if ((typeof (this.kvStore) !== 'undefined')) {
      return;
    }
    try {
      // Creates a KVManager object instance.
      this.kvManager = distributedKVStore.createKVManager({
        bundleName: this.context.abilityInfo.bundleName,
        context: this.context
      });
      let options: distributedKVStore.Options = {
        createIfMissing: true, // Indicates whether to create a database when the database file does not exist.
        encrypt: false, // Indicates whether to add database files.
        backup: false, // Indicates whether to back up database files.
        autoSync: true, // Indicates whether to automatically synchronize database files.
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION, // Set the type of database to be created.
        securityLevel: distributedKVStore.SecurityLevel.S1// Setting the database security level.
      };
      // distributed key-value database.
      this.kvManager.getKVStore(
        CommonConstants.DB_STORE_ID,
        options,
        (err: BusinessError, store: distributedKVStore.SingleKVStore | undefined) => {
          if (err) {
            Logger.error(TAG, `Failed to get KVStore: code message is ${JSON.stringify(err)}`);
            return;
          }
          this.kvStore = store;
      });
    } catch (err) {
      Logger.error(TAG, `An unexpected error occurred, code message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * This command is used to shut down the specified KVStore database by package name.
   */
  closeKVStore(): void {
    try {
      this.kvManager?.closeKVStore(this.context.abilityInfo.bundleName, CommonConstants.DB_STORE_ID,
        (err: BusinessError) => {
          if (err !== undefined) {
            console.error(TAG, `Failed to close KVStore, error message is ${JSON.stringify(err)}`);
            return;
          }
          Logger.info(TAG, 'Succeeded in closing KVStore');
        });
    } catch (err) {
      Logger.error(TAG, `CloseKVStore an unexpected error occurred, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Deletes a specified KVStore database by package name.
   */
  deleteKVStore(): void {
    try {
      this.kvManager?.deleteKVStore(this.context.abilityInfo.bundleName, CommonConstants.DB_STORE_ID);
    } catch (err) {
      Logger.error(TAG, `DeleteKVStore an unexpected error occurred, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Delete key-value pairs from the KVStore database in batches.
   *
   * @param keys Indicates the key-value pairs to be deleted in batches.
   * @param callback Callback function.
   */
  deleteBatch(keys: string[], callback: AsyncCallback<void>): void {
    try {
      this.kvStore?.deleteBatch(keys, callback);
    } catch (err) {
      Logger.error(TAG, `DeleteKVStore an unexpected error occurred, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Subscribe to distributed data changes.
   *
   * @param callback Callback function.
   */
  subscriptionKvStore(callback: Callback<distributedKVStore.ChangeNotification>): void {
    try {
      this.kvStore?.on('dataChange', distributedKVStore.SubscribeType.SUBSCRIBE_TYPE_REMOTE, callback);
    } catch (err) {
      Logger.error(TAG, `DataChange an unexpected error occured, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Adds a key-value pair of a specified type to the database.
   * If the key value exists, modify the data. Otherwise, add data.
   *
   * @param The Key Key of the data to be added.
   * @param The value of the data to be added.
   */
  save(key: string, value: string): void {
    try {
      this.kvStore?.put(key, value);
    } catch (err) {
      Logger.error(TAG, `Put an unexpected error occured, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Gets the value of a specified key.
   *
   * @param key Key of the data to be queried.
   * @param callback Callback function.
   */
  get(key: string, callback: AsyncCallback<boolean | string | number | Uint8Array>): void {
    try {
      this.kvStore?.get(key, callback);
    } catch (err) {
      Logger.error(TAG, `Fail to get, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Deletes data with a specified key value from the database.
   *
   * @param key Key of the data to be deleted.
   * @param callback Callback function.
   */
  delete(key: string, callback: AsyncCallback<void>): void {
    try {
      this.kvStore?.delete(key, callback);
    } catch (err) {
      Logger.error(TAG, `An unexpected error occurred, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Obtains all key-value pairs that match the specified key prefix.
   *
   * @param key Indicates the key prefix to be matched.
   * @param callback Callback function.
   */
  getEntries(key: string, callback: AsyncCallback<distributedKVStore.Entry[]>): void {
    try {
      this.kvStore?.getEntries(key, callback);
    } catch (err) {
      Logger.error(TAG, `An unexpected error occurred, error message is ${JSON.stringify(err)}`);
    }
  }

  /**
   * Remove the data change listener.
   */
  removeDataChangeListener(): void {
    if (this.kvStore === null) {
      return;
    }
    try {
      this.kvStore?.off('dataChange');
    } catch (error) {
      Logger.error(TAG, `removeDataChangeListener off('dataChange') failed, code message is ${JSON.stringify(error)}`);
    }
  }
}
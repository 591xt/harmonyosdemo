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

import deviceManager from '@ohos.distributedDeviceManager';
import { Callback } from '@ohos.base'
import Logger from '../common/util/Logger';
import CommonConstants from '../common/constants/CommonConstants';

const TAG: string = 'RemoteDeviceModel';

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceBasicInfo> | null = [];
  public discoverList: Array<deviceManager.DeviceBasicInfo> = [];
  private callback: () => void = () => {
  };
  private authCallback: () => void = () => {
  };
  private deviceManager: deviceManager.DeviceManager | undefined = undefined;

  registerDeviceListCallback(callback: Callback<void>) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback);
      return;
    }
    try {
      // Create a device management instance.
      let dmInstance = deviceManager.createDeviceManager(CommonConstants.BUNDLE_NAME);
      this.deviceManager = dmInstance;
      this.registerDeviceListCallbackImplement(callback);
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw, error message is ${JSON.stringify(error)}`);
    }
  }

  changeStateOnline(device: deviceManager.DeviceBasicInfo) {
    if (this.deviceList !== null) {
      this.deviceList![this.deviceList!.length] = device;
    }
    Logger.info(TAG, `online, device list= ${JSON.stringify(this.deviceList)}`);
    this.callback();
    if (this.authCallback !== null) {
      this.authCallback();
      this.authCallback = () => {
      }
    }
  }

  changeStateOffline(device: deviceManager.DeviceBasicInfo) {
    if (this.deviceList !== null && this.deviceList!.length > 0) {
      let list: Array<deviceManager.DeviceBasicInfo> = [];
      for (let j = 0; j < this.deviceList!.length; j++) {
        if (this.deviceList![j].deviceId !== device.deviceId) {
          list[j] = device;
        }
      }
      this.deviceList = list;
    }
    Logger.info(TAG, `offline, updated device list=${JSON.stringify(device)}`);
    this.callback();
  }

  changeState(device: deviceManager.DeviceBasicInfo, state: number) {
    if (this.deviceList !== null && this.deviceList!.length <= 0) {
      this.callback();
      return;
    }
    if (this.deviceList !== null && state === deviceManager.DeviceStateChange.AVAILABLE) {
      let list: Array<deviceManager.DeviceBasicInfo> = new Array();
      for (let i = 0; i < this.deviceList!.length; i++) {
        if (this.deviceList![i].deviceId !== device.deviceId) {
          list[i] = device;
        }
      }
      this.deviceList = list;
      Logger.info(TAG, `ready, device list= ${JSON.stringify(device)}`);
      this.callback();
    } else {
      if (this.deviceList !== null) {
        for (let j = 0; j < this.deviceList!.length; j++) {
          if (this.deviceList![j].deviceId === device.deviceId) {
            this.deviceList![j] = device;
            break;
          }
        }
        Logger.info(TAG, `offline, device list= ${JSON.stringify(this.deviceList)}`);
        this.callback();
      }
    }
  }

  registerDeviceListCallbackImplement(callback: Callback<void>) {
    this.callback = callback;
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized');
      this.callback();
      return;
    }
    try {
      // This interface is used to obtain the list of all trusted devices.
      let list = this.deviceManager !== undefined ? this.deviceManager.getAvailableDeviceListSync() : null;
      Logger.info(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`);
      if (typeof (list) !== 'undefined' && JSON.stringify(list) !== '[]') {
        this.deviceList = list!;
      }
      Logger.info(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`);
    } catch (error) {
      Logger.error(TAG, `getTrustedDeviceListSync, error message is ${JSON.stringify(error)}`);
    }
    this.callback();
    try {
      if (this.deviceManager !== undefined) {
        // Register device status callback.
        this.deviceManager.on('deviceStateChange', (data) => {
          if (data === null) {
            return
          }
          Logger.info(TAG, `deviceStateChange data= ${JSON.stringify(data)}`)
          switch (data.action) {
            // Physical devices go online.
            case deviceManager.DeviceStateChange.AVAILABLE:
              this.changeState(data.device, deviceManager.DeviceStateChange.AVAILABLE);
              break;
            // Device availability status.
            case deviceManager.DeviceStateChange.UNKNOWN:
              this.changeStateOnline(data.device);
              break;
            // Physical offline of the device.
            case deviceManager.DeviceStateChange.UNAVAILABLE:
              this.changeStateOffline(data.device);
              break;
            default:
              break;
          }
        })
      }
      if (this.deviceManager !== undefined) {
        // This interface is used to call back the listener when the device is successfully registered and discovered.
        this.deviceManager.on('discoverSuccess', (data) => {
          if (data === null) {
            return;
          }
          this.discoverList = [];
          Logger.info(TAG, `discoverSuccess data=${JSON.stringify(data)}`);
          this.deviceFound(data.device);
        })
        // Callback listener for device discovery failure.
        this.deviceManager.on('discoverFailure', (data) => {
          Logger.info(TAG, `discoverFailure data= ${JSON.stringify(data)}`);
        })
        // Registers the dead listener of the device management service.
        this.deviceManager.on('serviceDie', () => {
          Logger.error(TAG, 'serviceDie');
        })
      }
    } catch (error) {
      Logger.error(TAG, `on throw, error message is ${JSON.stringify(error)}`);
    }
    this.startDeviceDiscovery();
  }

  deviceFound(data: deviceManager.DeviceBasicInfo) {
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.deviceId) {
        Logger.info(TAG, 'device founded ignored');
        return;
      }
    }
    this.discoverList[this.discoverList.length] = data;
    Logger.info(TAG, `deviceFound self.discoverList= ${this.discoverList}`);
    this.callback();
  }

  /**
   * Searching for Devices on a Distributed Network by SUBSCRIBE_ID.
   */
  startDeviceDiscovery() {
    let discoverParam: Record<string, number> = {
      'discoverTargetType': 1
    };
    let filterOptions: Record<string, number> = {
      'availableStatus': 0
    };
    try {
      if (this.deviceManager !== undefined) {
        // Discover peripheral devices. The discovery status lasts for two minutes.
        // If the discovery status exceeds two minutes, the discovery stops. A maximum of 99 nodes can be discovered.
        this.deviceManager.startDiscovering(discoverParam, filterOptions);
      }
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw, error message is ${JSON.stringify(error)}`);
    }
  }

  unregisterDeviceListCallback() {
    if (this.deviceManager === undefined) {
      return;
    }
    if (this.deviceManager !== undefined) {
      try {
        // Stop detecting peripheral devices.
        this.deviceManager.stopDiscovering();
      } catch (error) {
        Logger.error(TAG, `stopDeviceDiscovery throw, error message is ${JSON.stringify(error)}`);
      }
      try {
        // Device status cancellation callback.
        this.deviceManager.off('deviceStateChange');
        // Callback for successful deregistration of device discovery.
        this.deviceManager.off('discoverSuccess');
        // Callback when device discovery fails to be deregistered.
        this.deviceManager.off('discoverFailure');
        // This interface is used to unregister the dead listener of the device management service.
        this.deviceManager.off('serviceDie');
      } catch (error) {
        Logger.error(TAG, `off throw, error message is ${JSON.stringify(error)}`);
      }
    }
    this.deviceList = [];
    this.discoverList = [];
  }

  authenticateDevice(device: deviceManager.DeviceBasicInfo, callBack: Callback<void>) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`);
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue;
      }
      try {
        if (this.deviceManager !== undefined) {
          // Authenticate the device.
          this.deviceManager.bindTarget(device.deviceId, {
            bindType: 1,
            targetPkgName: CommonConstants.BUNDLE_NAME,
            appName: CommonConstants.APP_NAME
          }, (err, data) => {
            if (err) {
              Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`);
              this.authCallback = () => {
              }
              return;
            }
            Logger.info(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`);
            this.authCallback = callBack;
          });
        }
      } catch (error) {
        Logger.error(TAG, `authenticateDevice throw, error message is ${JSON.stringify(error)}`);
      }
    }
  }
}
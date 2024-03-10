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
import promptAction from '@ohos.promptAction';
import resourceManager from '@ohos.resourceManager';
import { PreferenceManager } from '@ohos/datastore';
import { LoadingStatus, Logger, ObservedArray } from '@ohos/utils';
import { Achieve } from './Achieve';
import { UserNetFunc } from '../service/UserNetFunc';
import { LearningResource } from './LearningResource';
import { UserAccount } from './UserAccount';
import { UserData } from './UserData';
import { ActionEventData, EventTypeEnum } from './ActionEventData';

const TAG = '[UserModeL]';


/**
 * TOAST message position
 */
const TOAST_POSITION: number = 360;
const LOGIN_USER: string = 'logged_user';

let resource: resourceManager.Resource = {
  bundleName: $r('app.string.failed_message').bundleName,
  moduleName: $r('app.string.failed_message').moduleName,
  id: $r('app.string.failed_message').id
};


export class UserModel {
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();
  private funNetwork: UserNetFunc;
  private static instance: UserModel;
  private eventHub: common.EventHub = (getContext(this) as common.UIAbilityContext).eventHub;
  collectedIds: ObservedArray<string> = new ObservedArray();
  likedIds: ObservedArray<string> = new ObservedArray();
  learnedIds: ObservedArray<string> = new ObservedArray();
  userViewedResources: ObservedArray<LearningResource> = new ObservedArray<LearningResource>();
  userCollectedResources: ObservedArray<LearningResource> = new ObservedArray<LearningResource>();
  loadingViewedStatus: LoadingStatus = LoadingStatus.OFF;
  loadingCollectedStatus: LoadingStatus = LoadingStatus.OFF;

  constructor() {
    this.funNetwork = new UserNetFunc();
    this.eventHub.on(EventTypeEnum.COLLECTED, (eventData: ActionEventData): void => this.handleCollectEvent(eventData));
    this.eventHub.on(EventTypeEnum.LIKED, (eventData: ActionEventData): void => this.handleLikeEvent(eventData));
    this.eventHub.on(EventTypeEnum.LEARNING, (learningId: string): void => this.handleLearningEvent(learningId));
    this.eventHub.on(EventTypeEnum.VIEW, (resourceId: string): void => this.setViewsCount(resourceId));
  }

  public static getInstance(): UserModel {
    if (!UserModel.instance) {
      UserModel.instance = new UserModel();
    }
    return UserModel.instance;
  }

  showFailedToast() {
    getContext(this).resourceManager.getStringValue(resource).then(value => {
      promptAction.showToast({ message: value, bottom: TOAST_POSITION });
    });
  }

  reload(curTab: TabInfo): void {
    switch (curTab) {
      case TabInfo.COLLECTED:
        this.getCollectedResources();
        break
      case TabInfo.VIEWED:
        this.getViewedResources();
        break
      case TabInfo.ACHIEVEMENT:
        this.getUserAchievements();
        break
      default:
        break
    }
  }

  login(username: string, password: string): Promise<UserAccount | null> {
    return this.funNetwork.login(username, password).then((data?: UserAccount | null) => {
      if (data?.username === username) {
        this.preferenceManager.setValue<UserAccount>(LOGIN_USER, data);
        return data;
      }
      return null;
    });
  }

  /**
   * Save UserAccount to Preference
   * @param userAccount
   */
  saveUserAccount(userAccount: UserAccount): void {
    this.preferenceManager.setValue<UserAccount>(LOGIN_USER, userAccount);
  }

  getUserAccount(): Promise<UserAccount | null> {
    return this.preferenceManager.getValue<UserAccount>(LOGIN_USER);
  }

  getUserData(): void {
    this.funNetwork.getUserData().then((data: UserData) => {
      this.collectedIds.length = 0;
      this.likedIds.length = 0;
      data.collectedIds.forEach((item: string) => {
        this.collectedIds.push(item)
      })
      data.likedIds.forEach((item: string) => {
        this.likedIds.push(item)
      })
    })
  }

  getViewedResources(): Promise<void> {
    this.loadingViewedStatus = LoadingStatus.LOADING;
    return this.funNetwork.getViewedResources().then((data: LearningResource[]) => {
      this.userViewedResources.length = 0;
      data.forEach((res: LearningResource) => {
        this.userViewedResources.push(new LearningResource(res));
      });
      this.loadingViewedStatus = LoadingStatus.SUCCESS;
    }).catch((error: Error) => {
      this.showFailedToast();
      Logger.error(TAG, `LoadMore Viewed failed! Error message is ${error}`);
    });
  }

  getCollectedResources(): Promise<void> {
    this.loadingCollectedStatus = LoadingStatus.LOADING;
    return this.funNetwork.getCollectedResources().then((data: LearningResource[]) => {
      this.userCollectedResources.length = 0;
      data.forEach((res: LearningResource) => {
        this.userCollectedResources.push(new LearningResource(res));
      })
      this.loadingCollectedStatus = LoadingStatus.SUCCESS;
      Logger.error(TAG, `Load Collected Resources Success!`);
    }).catch((error: Error) => {
      this.showFailedToast()
      Logger.error(TAG, `Load Collected failed! Error message is ${error}`);
    })
  }

  getUserAchievements(): void {
    this.funNetwork.getAchievements().then((data: Achieve[]) => {
      this.learnedIds.length = 0;
      data.forEach((item: Achieve) => {
        if (item.isLearned) {
          this.learnedIds.push(item.pathId);
        }
      });
      Logger.info(TAG, 'Load Achievements Success!!' + JSON.stringify(this.learnedIds));
    }).catch((error: Error) => {
      this.showFailedToast()
      Logger.error(TAG, `LoadMore Achievements failed! Error message is ${error}`);
    })
  }

  handleCollected(resourceId: string): void {
    const index = this.collectedIds.findIndex((id: string) => id === resourceId);
    if (index === -1) {
      this.collectedIds.push(resourceId);
    } else {
      this.collectedIds.splice(index, 1);
    }
    this.funNetwork.toggleCollected(resourceId, index === -1 ? 1 : 0);
  }

  setCollectionCount(resourceId: string, isCollected: boolean): void {
    this.userCollectedResources.forEach((res: LearningResource) => {
      if (res.id === resourceId) {
        res.collectionCount += isCollected ? 1 : -1;
      }
    });
    this.userViewedResources.forEach((res: LearningResource) => {
      if (res.id === resourceId) {
        res.collectionCount += isCollected ? 1 : -1;
      }
    });
  }

  handleCollectEvent(eventData: ActionEventData): void {
    const resourceId: string = eventData.resourceId;
    const actionValue: boolean = eventData.actionValue;
    this.handleCollected(resourceId);
    this.setCollectionCount(resourceId, actionValue);
  }

  handleLiked(resourceId: string): void {
    const index = this.likedIds.findIndex((id: string) => id === resourceId);
    if (index === -1) {
      this.likedIds.push(resourceId);
    } else {
      this.likedIds.splice(index, 1);
    }
    this.funNetwork.toggleLiked(resourceId, index === -1 ? 1 : 0);
  }

  setLikesCount(resourceId: string, isLiked: boolean): void {
    this.userCollectedResources.forEach((res: LearningResource) => {
      if (res.id === resourceId) {
        res.likesCount += isLiked ? 1 : -1;
      }
    });
    this.userViewedResources.forEach((res: LearningResource) => {
      if (res.id === resourceId) {
        res.likesCount += isLiked ? 1 : -1;
      }
    })
  }

  handleLikeEvent(eventData: ActionEventData): void {
    const resourceId: string = eventData.resourceId;
    const actionValue: boolean = eventData.actionValue;
    this.handleLiked(resourceId);
    this.setLikesCount(resourceId, actionValue);
  }

  handleLearningEvent(learningId: string): void {
    this.learnedIds.push(learningId);
  }

  setViewsCount(resourceId: string): void {
    this.userViewedResources.forEach((res: LearningResource) => {
      if (res.id === resourceId) {
        res.viewsCount += 1;
      }
    });
    this.userCollectedResources.forEach((res: LearningResource) => {
      if (res.id === resourceId) {
        res.viewsCount += 1;
      }
    });
  }
}

export enum TabInfo {
  COLLECTED = 0,
  VIEWED,
  ACHIEVEMENT
}

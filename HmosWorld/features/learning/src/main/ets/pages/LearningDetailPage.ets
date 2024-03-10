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
import router from '@ohos.router';
import webview from '@ohos.web.webview';
import { Logger } from '@ohos/utils';
import { TopNavigationView, WebView } from '@ohos/uicomponents';
import { LearningConstants } from '../constants/LearningConstants';
import { LearningPath } from '../entity/LearningPath';

const TAG = '[LearningDetailPage]';

const LEARN_MIN_DURATION = 5;

@Entry
@Component
struct LearningDetailPage {
  @State learningItem: LearningPath = (router.getParams() as Record<string, LearningPath>)['learningItem'] as LearningPath;
  @State webViewController: webview.WebviewController = new webview.WebviewController();
  private intervalId?: number;
  private learnSeconds: number = 0;

  onBackPress() {
    if (this.webViewController.getUrl() !== this.learningItem.url) {
      this.webViewController.backward();
      return true;
    }
    let bundleName = (getContext(this) as common.UIAbilityContext).applicationInfo.name;
    if (this.learningItem.isLearned === false && this.learnSeconds >= LEARN_MIN_DURATION) {
      AppStorage.setOrCreate<boolean>('isLearned', true);
      router.back({
        url: `@bundle:${bundleName}/phone/ets/pages/MainPage`,
        params: { learningId: this.learningItem.id }
      });
    } else {
      router.back();
    }
    return true;
  }

  onPageHide() {
    if (this.intervalId && this.intervalId > -1) {
      clearInterval();
      this.intervalId = undefined;
    }
  }

  startLearning(): void {
    if (!this.intervalId && (!this.learningItem.isLearned)) {
      this.learnSeconds = 0;
      this.intervalId = setInterval(() => {
        this.learnSeconds++;
        Logger.info(TAG, 'learnSeconds: ' + this.learnSeconds);
        if (this.learnSeconds === LEARN_MIN_DURATION) {
          clearInterval(this.intervalId);
          Logger.info(TAG, 'learning completed');
        }
      }, LearningConstants.ANIMATION_DURATION_NORMAL);
    }
  }

  build() {
    Stack() {
      Column() {
        TopNavigationView({
          title: this.learningItem.title,
          onBackClick: () => {
            this.onBackPress();
          }
        })

        WebView({
          url: this.learningItem.url,
          webViewController: $webViewController,
          handlePageEnd: () => {
            this.startLearning();
          }
        })
      }
    }
    .padding({ top: AppStorage.get<number>('statusBarHeight') })
    .width(LearningConstants.FULL_PERCENT)
    .height(LearningConstants.FULL_PERCENT)
  }
}
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
import router from '@ohos:router';
import Logger from '@bundle:com.huawei.firststartdemo/entry/ets/common/utils/Logger';
import CommonConstants from '@bundle:com.huawei.firststartdemo/entry/ets/common/constants/CommonConstants';
class AdvertisingPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1) {
        super(parent, __localStorage, elmtId);
        this.__countDownSeconds = new ObservedPropertySimplePU(CommonConstants.ADVERTISING_COUNT_DOWN_SECONDS, this, "countDownSeconds");
        this.timeId = 0;
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params) {
        if (params.countDownSeconds !== undefined) {
            this.countDownSeconds = params.countDownSeconds;
        }
        if (params.timeId !== undefined) {
            this.timeId = params.timeId;
        }
    }
    updateStateVars(params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__countDownSeconds.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__countDownSeconds.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    get countDownSeconds() {
        return this.__countDownSeconds.get();
    }
    set countDownSeconds(newValue) {
        this.__countDownSeconds.set(newValue);
    }
    onPageShow() {
        this.timeId = setInterval(() => {
            if (this.countDownSeconds === 0) {
                this.jumpToAppHomePage();
            }
            else {
                this.countDownSeconds--;
            }
        }, CommonConstants.ADVERTISING_INTERVAL_TIME);
    }
    onPageHide() {
        router.clear();
        clearInterval(this.timeId);
    }
    /**
     * Jump to app home page.
     */
    jumpToAppHomePage() {
        router.pushUrl({
            url: CommonConstants.APP_HOME_PAGE_URL
        }).catch((error) => {
            Logger.error(CommonConstants.ADVERTISING_PAGE_TAG, 'AdvertisingPage pushUrl error ' + JSON.stringify(error));
        });
    }
    initialRender() {
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Stack.create({ alignContent: Alignment.Top });
            Stack.width(CommonConstants.FULL_WIDTH);
            Stack.height(CommonConstants.FULL_HEIGHT);
            if (!isInitialRender) {
                Stack.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Image.create({ "id": 16777282, "type": 20000, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.width(CommonConstants.FULL_WIDTH);
            Image.height(CommonConstants.FULL_HEIGHT);
            if (!isInitialRender) {
                Image.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777220, "type": 10003, params: [this.countDownSeconds], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontColor(Color.White);
            Text.fontSize({ "id": 16777248, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.letterSpacing(CommonConstants.ADVERTISING_TITLE_TEXT_LETTER_SPACING);
            Text.backgroundColor({ "id": 16777234, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.border({
                radius: { "id": 16777255, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                width: { "id": 16777247, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                color: Color.White
            });
            Text.margin({
                top: { "id": 16777258, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                left: { "id": 16777257, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }
            });
            Text.padding({
                left: { "id": 16777252, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                top: { "id": 16777254, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                right: { "id": 16777252, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                bottom: { "id": 16777251, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }
            });
            Text.onClick(() => {
                this.jumpToAppHomePage();
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Row.create();
            Row.alignItems(VerticalAlign.Bottom);
            Row.height(CommonConstants.FULL_HEIGHT);
            if (!isInitialRender) {
                Row.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Image.create({ "id": 16777285, "type": 20000, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.width({ "id": 16777246, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.height({ "id": 16777245, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.margin({ bottom: CommonConstants.ADVERTISING_ROW_MARGIN_BOTTOM });
            if (!isInitialRender) {
                Image.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Column.create();
            Column.alignItems(HorizontalAlign.Start);
            Column.margin({
                left: CommonConstants.ADVERTISING_COLUMN_MARGIN_LEFT,
                bottom: CommonConstants.ADVERTISING_ROW_MARGIN_BOTTOM
            });
            if (!isInitialRender) {
                Column.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777228, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            __Text__bottomTextStyle(FontWeight.Bolder, CommonConstants.ADVERTISING_HEALTHY_LIFE_TEXT_SPACING, { "id": 16777256, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }, { "id": 16777235, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777227, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            __Text__bottomTextStyle(FontWeight.Normal, CommonConstants.ADVERTISING_TEXT_INTRODUCE_LETTER_SPACING, { "id": 16777249, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }, { "id": 16777241, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.opacity({ "id": 16777250, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.margin({ top: CommonConstants.ADVERTISING_TEXT_INTRODUCE_MARGIN_TOP });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        Column.pop();
        Row.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
// Bottom text common style.
function __Text__bottomTextStyle(fontWeight, textAttribute, fontSize, fontColor) {
    Text.fontWeight(fontWeight);
    Text.letterSpacing(textAttribute);
    Text.fontSize(fontSize);
    Text.fontColor(fontColor);
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new AdvertisingPage(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
//# sourceMappingURL=AdvertisingPage.js.map
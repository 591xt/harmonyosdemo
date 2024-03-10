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
import { GlobalContext } from '@bundle:com.huawei.firststartdemo/entry/ets/common/utils/GlobalContext';
export default class CustomDialogComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1) {
        super(parent, __localStorage, elmtId);
        this.controller = new CustomDialogController({
            'builder': ''
        }, this);
        this.cancel = () => { };
        this.confirm = () => { };
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.cancel !== undefined) {
            this.cancel = params.cancel;
        }
        if (params.confirm !== undefined) {
            this.confirm = params.confirm;
        }
    }
    updateStateVars(params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    setController(ctr) {
        this.controller = ctr;
    }
    initialRender() {
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Column.create();
            Column.width(CommonConstants.DIALOG_WIDTH_PERCENT);
            Column.borderRadius(CommonConstants.DIALOG_BORDER_RADIUS);
            Column.backgroundColor(Color.White);
            if (!isInitialRender) {
                Column.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777226, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT);
            Text.fontColor({ "id": 16777238, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777266, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.textAlign(TextAlign.Center);
            Text.fontWeight(CommonConstants.DIALOG_TITLE_FONT_WEIGHT);
            Text.margin({
                top: { "id": 16777267, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                bottom: { "id": 16777265, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777224, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777261, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT);
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777225, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT);
            Text.fontColor({ "id": 16777239, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777261, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.onClick(() => {
                // globalThis.isJumpPrivacy = true;
                GlobalContext.getContext().setObject('isJumpPrivacy', true);
                router.pushUrl({
                    url: CommonConstants.PRIVACY_PAGE_URL
                }).catch((error) => {
                    Logger.error(CommonConstants.CUSTOM_DIALOG_TAG, 'CustomDialog pushUrl error ' + JSON.stringify(error));
                });
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777223, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT);
            Text.fontColor({ "id": 16777238, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777261, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.opacity({ "id": 16777264, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.margin({ bottom: { "id": 16777263, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" } });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Row.create();
            Row.margin({ bottom: CommonConstants.DIALOG_ROW_MARGIN_BOTTOM });
            if (!isInitialRender) {
                Row.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777222, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            __Text__fancy();
            Text.onClick(() => {
                this.controller.close();
                this.cancel();
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Blank.create();
            Blank.backgroundColor({ "id": 16777236, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Blank.width({ "id": 16777260, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Blank.height({ "id": 16777259, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            if (!isInitialRender) {
                Blank.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Blank.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777221, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            __Text__fancy();
            Text.onClick(() => {
                this.controller.close();
                this.confirm();
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
// Common text styles.
function __Text__fancy() {
    Text.fontColor({ "id": 16777237, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
    Text.fontSize({ "id": 16777262, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
    Text.textAlign(TextAlign.Center);
    Text.fontWeight(FontWeight.Medium);
    Text.layoutWeight(CommonConstants.COMMON_LAYOUT_WEIGHT);
}
//# sourceMappingURL=CustomDialogComponent.js.map
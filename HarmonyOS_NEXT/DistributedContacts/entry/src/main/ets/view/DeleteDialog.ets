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

import CommonConstants from '../common/constants/CommonConstants';

@CustomDialog
export struct DeleteDialog {
  private controller: CustomDialogController;
  private cancel: () => void = () => {
  };
  private confirm: () => void = () => {
  };
  private promptMessage: Resource = $r('app.string.batch_delete_text');

  build() {
    Column() {
      Text(this.promptMessage)
        .fontSize($r('app.float.popup_font_size'))
        .margin({
          top: $r('app.float.delete_text_margin_top'),
          bottom: $r('app.float.delete_text_margin_bottom')
        })
      Row() {
        Button($r('app.string.delete_cancel_text'))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })
          .backgroundColor(Color.White)
          .fontColor($r('app.color.cancel_font_color'))
        Divider()
          .width($r('app.float.divider_height'))
          .height(CommonConstants.BOTTOM_COMPONENT_WIDTH)
          .backgroundColor($r('app.color.list_divider'))
          .margin({
            right: $r('app.float.delete_divider_margin'),
            left: $r('app.float.delete_divider_margin')
          })
        Button($r('app.string.bottom_text_deletion'))
          .onClick(() => {
            this.controller.close();
            this.confirm();
          })
          .backgroundColor(Color.White)
          .fontColor(Color.Red)
      }
      .width(CommonConstants.PERCENTAGE_MAX)
      .height($r('app.float.delete_height'))
      .margin({ bottom: $r('app.float.delete_dialog_margin') })
      .justifyContent(FlexAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.delete_dialog_height'))
    .backgroundColor(Color.White)
    .border({
      color: Color.White,
      radius: ($r('app.float.device_list_border_radius'))
    })
  }
}
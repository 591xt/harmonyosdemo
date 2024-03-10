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
import prompt from '@ohos.promptAction';
import CommonConstants from '../common/constants/CommonConstants';

@Extend(Text)
function ButtonTextStyle() {
  .fontColor($r('app.color.button_text_color'))
  .fontSize($r('app.float.button_font_size'))
  .fontWeight(CommonConstants.FONT_WEIGHT_500)
}

@CustomDialog
export default struct DeviceListDialogComponent {
  controller?: CustomDialogController;
  @StorageLink('deviceList') deviceList: Array<deviceManager.DeviceBasicInfo> = AppStorage.get('deviceList')!;
  private selectedIndex: number | undefined = 0;
  private onSelectedIndexChange: (selectedIndex: number | undefined) => void = () => {
  };
  @State deviceDialogWidth: number = 0;

  build() {
    Column() {
      Row() {
        Text($r('app.string.select_device'))
          .fontSize($r('app.float.dialog_title_font_size'))
          .width(CommonConstants.FULL_PERCENT)
          .textAlign(TextAlign.Start)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
      }
      .padding({
        left: $r('app.float.dialog_title_padding_left'),
        right: $r('app.float.dialog_title_padding_left'),
        top: $r('app.float.dialog_title_padding_top')
      })
      .height($r('app.float.dialog_title_height'))

      List() {
        ForEach(this.deviceList, (item: deviceManager.DeviceBasicInfo, index: number | undefined) => {
          ListItem() {
            Column() {
              Row() {
                Row() {
                  Row() {
                    Image(this.getDeviceTypeIcon())
                      .opacity($r('app.float.device_icon_opacity'))
                  }
                  .width($r('app.float.device_icon_width'))
                  .aspectRatio(CommonConstants.NUMBER_ONE)

                  Text(item.deviceName)
                    .fontSize($r('app.float.device_name_font_size'))
                    .width(CommonConstants.DEVICE_NAME_WIDTH)
                    .fontColor(Color.Black)
                    .margin({ left: $r('app.float.device_name_margin_left') })
                    .maxLines(CommonConstants.NUMBER_ONE)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .textAlign(TextAlign.Start)
                }
                .justifyContent(FlexAlign.Start)

                if (index === this.selectedIndex) {
                  Image($r('app.media.ic_single_select'))
                    .width(CommonConstants.SELECT_ICON_WIDTH)
                    .objectFit(ImageFit.Contain)
                } else {
                  Image($r('app.media.ic_single_unselect'))
                    .width(CommonConstants.SELECT_ICON_WIDTH)
                    .objectFit(ImageFit.Contain)
                    .opacity($r('app.float.icon_uncheck_opacity'))
                }
              }
              .height($r('app.float.device_info_height'))
              .onClick(() => {
                if (this.selectedIndex !== undefined && index === this.selectedIndex) {
                  return;
                } else if (this.selectedIndex !== undefined) {
                  this.selectedIndex = index;
                  this.onSelectedIndexChange(this.selectedIndex);
                }
              })
              .padding({
                left: $r('app.float.device_info_padding'),
                right: $r('app.float.device_info_padding')
              })
              .width(CommonConstants.FULL_PERCENT)
              .justifyContent(FlexAlign.SpaceBetween)

              if (index !== this.deviceList.length - 1) {
                Row() {
                  Divider()
                    .width(CommonConstants.FULL_PERCENT)
                    .height($r('app.float.device_info_divider_height'))
                    .opacity($r('app.float.device_info_divider_opacity'))
                }
                .padding({
                  left: $r('app.float.device_info_divider_padding_left'),
                  right: $r('app.float.device_info_divider_padding_right')
                })
                .width(CommonConstants.FULL_PERCENT)
              }
            }
          }
        }, (item: deviceManager.DeviceBasicInfo) => JSON.stringify(item))
      }
      .width(CommonConstants.FULL_PERCENT)

      Row() {
        Column() {
          Text($r('app.string.select_device_cancel'))
            .ButtonTextStyle()
        }
        .layoutWeight(CommonConstants.NUMBER_ONE)
        .justifyContent(FlexAlign.Center)
        .height($r('app.float.button_line_height'))
        .onClick(() => {
          if (this.controller !== undefined) {
            this.controller.close();
          }
        })

        Divider()
          .vertical(true)
          .height($r('app.float.button_line_divider_height'))
          .color($r('app.color.button_line_divider_color'))
          .width($r('app.float.button_line_divider_width'))

        Column() {
          Text($r('app.string.confirm'))
            .ButtonTextStyle()
        }
        .layoutWeight(CommonConstants.NUMBER_ONE)
        .justifyContent(FlexAlign.Center)
        .height($r('app.float.button_line_height'))
        .onClick(() => {
          if (CommonConstants.INVALID_INDEX === this.selectedIndex) {
            prompt.showToast({
              message: $r('app.string.please_select_device')
            });
          } else {
            if (this.controller !== undefined) {
              this.onSelectedIndexChange(this.selectedIndex);
            }
          }
        })
      }
      .backgroundColor(Color.White)
      .border({
        color: Color.White,
        radius: $r('app.float.button_line_radius')
      })
      .padding($r('app.float.button_line_padding'))
      .margin({ top: $r('app.float.button_line_margin_top') })
    }
  }

  getDeviceTypeIcon(): Resource {
    return $r('app.media.ic_public_devices_phone');
  }
}
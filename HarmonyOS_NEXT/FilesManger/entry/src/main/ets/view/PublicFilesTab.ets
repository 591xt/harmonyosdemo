/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import photoAccessHelper from '@ohos.file.photoAccessHelper'
import fs from '@ohos.file.fs';
import Logger from '../common/utils/Logger';
import { readUserFile, saveToUser } from '../common/utils/SavingAndSelectUserFile'
import { photoPickerGetUri } from '../common/utils/PictureSaving';

@Component
export struct publicFilesTab {
  @State picture: string = '';
  @State flag: Boolean = false;
  @State message: string = '';
  @State content: string = '';
  @State isInput: Boolean = false;
  // Setting the button properties of a security control
  @State saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.img'))
          .borderRadius($r('app.float.default_24'))
          .width($r('app.float.default_312'))
          .height($r('app.float.default_147'))
        // Create Security Control Button
        SaveButton(this.saveButtonOptions)
          .onClick(async (event, result: SaveButtonOnClickResult) => {
            if (result == SaveButtonOnClickResult.SUCCESS) {
              try {
                Logger.info('createAsset successfully, event: ' + event);
                let context = getContext();
                let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
                // Creating a Media File
                let uri = await phAccessHelper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
                Logger.info('createAsset successfully, uri: ' + uri);
                // Open the created media file and read the local file and convert it to ArrayBuffer for easy filling.
                let file = await fs.open(uri, fs.OpenMode.READ_WRITE);
                let buffer = getContext(this).resourceManager.getMediaContentSync($r('app.media.img').id);
                // Write the read ArrayBuffer to the new media file.
                let writeLen = await fs.write(file.fd, buffer.buffer);
                Logger.info('write success,len=' + writeLen);
                await fs.close(file);
              } catch (err) {
                Logger.error('createAsset failed, message = ', err);
              }
            } else {
              Logger.error('SaveButtonOnClickResult createAsset failed');
            }
          })
      }
      .margin({ bottom: $r('app.float.default_10') })
      .width($r('app.float.default_336'))
      .height($r('app.float.default_223'))
      .borderRadius($r('app.float.default_24'))
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor($r('app.color.start_window_background'))

      Column() {
        Text($r('app.string.select_photo'))
          .width($r('app.float.default_302'))
          .height($r('app.float.default_48'))
          .lineHeight($r('app.float.default_22'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize($r('app.float.default_16'))
          .fontWeight(500)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.text_color'))
        Column() {
          if (!this.flag) {
            Image($r('app.media.ic_folder_add2'))
              .width($r('app.float.default_24'))
              .height($r('app.float.default_24'))
              .objectFit(ImageFit.Contain)
          } else {
            Image(this.picture)
              .width('100%')
              .height('100%')
              .borderRadius($r('app.float.default_24'))
          }
        }
        .width($r('app.float.default_312'))
        .height($r('app.float.default_147'))
        .borderRadius($r('app.float.default_16'))
        .backgroundColor($r('app.color.picture_background'))
        .onClick(async () => {
          await photoPickerGetUri().then(value => {
            this.flag = true;
            this.picture = value;
          });
        })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .margin({ bottom: $r('app.float.default_10') })
      .backgroundColor($r('app.color.start_window_background'))
      .width($r('app.float.default_336'))
      .height($r('app.float.default_213'))
      .borderRadius($r('app.float.default_24'))

      Column() {
        TextArea({ placeholder: $r('app.string.textarea_default2'), text: this.isInput ? this.content : this.message })
          .onChange((value: string) => {
            this.content = value;
          })
          .width($r('app.float.default_312'))
          .height($r('app.float.default_120'))
          .margin({ top: $r('app.float.default_10'), bottom: $r('app.float.default_10') })
          .enableKeyboardOnFocus(false)
        Button($r('app.string.button3'))
          .width($r('app.float.default_312'))
          .height($r('app.float.default_40'))
          .onClick(() => {
            saveToUser(this.content)
            this.content = '';
            this.isInput = true;
          })
          .margin({ bottom: $r('app.float.default_10') })
        Button($r('app.string.button4'))
          .width($r('app.float.default_312'))
          .height($r('app.float.default_40'))
          .onClick(async () => {
            await readUserFile().then((value: string) => {
              this.message = value;
              this.isInput = false;
            })
          })
      }
      .backgroundColor($r('app.color.start_window_background'))
      .width($r('app.float.default_336'))
      .height('251')
      .borderRadius($r('app.float.default_24'))
      .margin({ bottom: $r('app.float.default_100') })
    }
    .width('100%')
  }
}
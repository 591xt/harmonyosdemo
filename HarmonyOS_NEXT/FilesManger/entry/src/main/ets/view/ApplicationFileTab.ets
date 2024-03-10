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
import { readFile } from '../common/utils/ReadFile';
import { writeFile } from '../common/utils/WriteFile';

@Component
export struct ApplicationFileTab {
  // Used to record the read content.
  @State message: string = '';
  // Used to record the contents of a text box.
  @State content: string = '';

  build() {
    Column() {
      Text($r('app.string.textarea_default'))
        .width($r('app.float.default_294'))
        .height($r('app.float.default_22'))
        .fontColor($r('app.color.text_color'))
        .fontWeight(500)
        .fontSize($r('app.float.default_16'))
        .fontFamily('HarmonyHeiTi-Medium')
        .lineHeight($r('app.float.default_22'))
        .textAlign(TextAlign.Start)
        .margin({
          top: $r('app.float.default_13'),
          bottom: $r('app.float.default_13'),
          right: $r('app.float.default_8')
        })
      TextArea({ text: this.content })
        .width($r('app.float.default_336'))
        .height($r('app.float.default_139'))
        .borderRadius($r('app.float.default_24'))
        .backgroundColor($r('app.color.start_window_background'))
        .enableKeyboardOnFocus(false)
        .onChange((value: string) => {
          this.content = value
        })
      Text($r('app.string.file_content'))
        .width($r('app.float.default_294'))
        .height($r('app.float.default_22'))
        .fontSize($r('app.float.default_16'))
        .lineHeight($r('app.float.default_22'))
        .fontWeight(500)
        .margin({
          top: $r('app.float.default_13'),
          bottom: $r('app.float.default_13'),
          right: $r('app.float.default_8')
        })
      TextArea({ text: this.message })
        .enableKeyboardOnFocus(false)
        .width($r('app.float.default_336'))
        .height($r('app.float.default_139'))
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius($r('app.float.default_24'))

      Column() {
        Button($r('app.string.button1'))
          .width($r('app.float.default_312'))
          .height($r('app.float.default_40'))
          // Write the information and clear the content so that the text box is cleared after you click Save.
          .onClick(() => {
            writeFile(this.content);
            this.content = ''
          })
        Button($r('app.string.button2'))
          .width($r('app.float.default_312'))
          .height($r('app.float.default_40'))
          .margin({ top: $r('app.float.default_12'), bottom: $r('app.float.default_100') })
          .onClick(() => {
            this.message = readFile();
          })
      }
      .width('100%')
      .margin({ top: $r('app.float.default_100') })
    }
    .width('100%')
    .height('100%')
  }
}
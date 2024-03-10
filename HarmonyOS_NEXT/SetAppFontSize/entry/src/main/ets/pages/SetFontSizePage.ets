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

import ChatItemComponent from '../view/ChatItemComponent';
import TitleBarComponent from '../view/TitleBarComponent';
import SetViewModel from '../viewmodel/SetViewModel';
import CommonConstants from '../common/constants/CommonConstants';
import StyleConstants from '../common/constants/StyleConstants';
import ChatData from '../viewmodel/ChatData';
import dataPreferences from '@ohos.data.preferences';

const TAG = '[SetFontSizePage]';
const KEY_APP_FONT_SIZE = 'appFontSize';

/**
 * The SetFontSizePage is the page that sets the font size.
 * The page consists of title, chat list, and slider.
 * Drag the slider to change the font size of the chat list.
 */
@Entry
@Component
struct SetFontSizePage {
  private contentArr = SetViewModel.initChatData();
  @State changeFontSize: number = 0;
  @State fontSizeText: Resource = $r("app.string.set_size_normal");

  onPageShow() {
    dataPreferences.getPreferences(getContext(this), 'myStore').then((object: dataPreferences.Preferences) => {
      object.get(KEY_APP_FONT_SIZE, 0).then((data) => {
        this.changeFontSize = Number(data);
        this.fontSizeText = SetViewModel.getTextByFontSize(Number(data));
      });
    })
  }

  build() {
    Column() {
      TitleBarComponent({ title: $r('app.string.set_title') })

      if (this.changeFontSize > 0) {
        List() {
          ForEach(this.contentArr, (item: ChatData) => {
            ListItem() {
              ChatItemComponent({ item: item, changeFontSize: this.changeFontSize })
            }
          }, (item: ChatData) => JSON.stringify(item))
        }
        .layoutWeight(StyleConstants.WEIGHT_FULL)
      }

      SliderLayout({ fontSizeText: $fontSizeText, changeFontSize: $changeFontSize })
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .height(StyleConstants.FULL_HEIGHT)
    .width(StyleConstants.FULL_WIDTH)
  }
}

@Component
struct SliderLayout {
  @Link fontSizeText: Resource;
  @Link changeFontSize: number;

  build() {
    Column() {
      Text($r('app.string.set_font_size'))
        .fontSize($r('app.float.set_text'))
        .fontColor($r('app.color.text'))
        .margin({ left: StyleConstants.SLIDER_LAYOUT_LEFT_PERCENT, top: StyleConstants.SLIDER_LAYOUT_TOP_PERCENT })
        .fontWeight(FontWeight.Medium)

      Column() {
        Text(this.fontSizeText)
          .fontSize($r('app.float.set_text'))
          .fontColor($r('app.color.text'))

        Row() {
          Text($r('app.string.set_char_a'))
            .fontColor($r('app.color.text'))
            .fontSize($r('app.float.set_small_a'))
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.End)
            .width(StyleConstants.A_WIDTH_PERCENT)
            .padding({ right: $r('app.float.a_right_padding') })

          Slider({
            value: this.changeFontSize === CommonConstants.SET_SIZE_HUGE
              ? CommonConstants.SET_SLIDER_MAX : this.changeFontSize,
            min: CommonConstants.SET_SLIDER_MIN,
            max: CommonConstants.SET_SLIDER_MAX,
            step: CommonConstants.SET_SLIDER_STEP,
            style: SliderStyle.InSet
          })
            .showSteps(true)
            .width(StyleConstants.SLIDER_WIDTH_PERCENT)
            .onChange(async (value: number) => {
              if (this.changeFontSize === 0) {
                this.fontSizeText = SetViewModel.getTextByFontSize(value);
                return;
              }
              this.changeFontSize = (value === CommonConstants.SET_SLIDER_MAX ? CommonConstants.SET_SIZE_HUGE : value);
              this.fontSizeText = SetViewModel.getTextByFontSize(this.changeFontSize);
              let preferences: dataPreferences.Preferences | null = null;
              dataPreferences.getPreferences(getContext(this), 'myStore').then((object: dataPreferences.Preferences) => {
                preferences = object;
                preferences.put(KEY_APP_FONT_SIZE, this.changeFontSize).then(() => {
                  preferences?.flush();
                });
              })
            })

          Text($r('app.string.set_char_a'))
            .fontColor($r('app.color.text'))
            .fontSize($r('app.float.set_big_a'))
            .fontWeight(FontWeight.Bold)
            .width(StyleConstants.A_WIDTH_PERCENT)
            .padding({ left: $r('app.float.a_left_padding') })
        }
      }
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.block_background_radius'))
      .width(StyleConstants.BLOCK_WIDTH_PERCENT)
      .padding({ top: $r('app.float.slider_top_padding'), bottom: $r('app.float.slider_bottom_padding') })
      .margin({
        left: StyleConstants.SLIDER_HORIZONTAL_MARGIN_PERCENT,
        right: StyleConstants.SLIDER_HORIZONTAL_MARGIN_PERCENT,
        top: StyleConstants.SLIDER_TOP_MARGIN_PERCENT,
        bottom: StyleConstants.SLIDER_BOTTOM_MARGIN_PERCENT
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.End)
  }
}
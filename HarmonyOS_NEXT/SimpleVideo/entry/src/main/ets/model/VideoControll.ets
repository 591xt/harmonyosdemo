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

import {
  COMMON_NUM_MINUTE,
  COMMON_NUM_DOUBLE,
  ZERO_STR,
  SPLIT,
  STACK_STYLE
} from '../common/constants/CommonConstants';
import { VideoPlayerModel } from './VideoPlayerModel';
import { DurationObject } from '../view/VideoPlayer';

/**
 * video component prepared callback
 */
export function prepared(model: VideoPlayerModel, event: DurationObject) {
  model.durationTime = event.duration;
  let second: number = event.duration % COMMON_NUM_MINUTE;
  let min: number = Number.parseInt((event.duration / COMMON_NUM_MINUTE).toString());
  let head = min < COMMON_NUM_DOUBLE ? `${ZERO_STR}${min}` : min;
  let end = second < COMMON_NUM_DOUBLE ? `${ZERO_STR}${second}` : second;
  model.durationStringTime = `${head}${SPLIT}${end}`;
  model.flag = true;
}

/**
 * video component finish callback
 */
export function finish(model: VideoPlayerModel) {
  model.isPlay = false;
  model.isOpacity = false;
}

/**
 * video slider component onchange callback
 */
export function sliderOnchange(model: VideoPlayerModel, value: number, mode: SliderChangeMode) {
  model.currentTime = Number.parseInt(value.toString());
  model.controller.setCurrentTime(Number.parseInt(value.toString()), SeekMode.Accurate);
  if (mode === SliderChangeMode.Begin) {
    model.isOpacity = false;
  }
  if (mode === SliderChangeMode.Moving) {
    model.isOpacity = false;
  }
  if (mode === SliderChangeMode.End) {
    model.isOpacity = true;
  }
}

/**
 * get video  string of current time
 * @param the number of current time
 * @return the string of current time
 */
export function changeSliderTime(value: number): string {
  let second: number = value % COMMON_NUM_MINUTE;
  let min: number = Number.parseInt((value / COMMON_NUM_MINUTE).toString());
  let head = min < COMMON_NUM_DOUBLE ? `${ZERO_STR}${min}` : min;
  let end = second < COMMON_NUM_DOUBLE ? `${ZERO_STR}${second}` : second;
  let nowTime = `${head}${SPLIT}${end}`;
  return nowTime;
}

/**
 * icon onclick callback
 */
export function iconOnclick(model: VideoPlayerModel) {
  if (model.isPlay === true) {
    model.controller.pause()
    model.isPlay = false;
    model.isOpacity = false;
    return;
  }
  if (model.flag === true) {
    model.controller.start();
    model.isPlay = true;
    model.isOpacity = true;
  } else {
    model.isLoading = true;
    // The video loading is not complete. The loading action is displayed.
    let intervalLoading = setInterval(() => {
      if (model.progressVal >= STACK_STYLE.PROGRESS_TOTAL) {
        model.progressVal = 0;
      } else {
        model.progressVal += STACK_STYLE.PROGRESS_STEP;
      }
    }, STACK_STYLE.MILLI_SECONDS)
    // The scheduled task determines whether the video loading is complete.
    let intervalFlag = setInterval(() => {
      if (model.flag === true) {
        model.controller.start();
        model.isPlay = true;
        model.isOpacity = true;
        model.isLoading = false;
        clearInterval(intervalFlag);
        clearInterval(intervalLoading);
      }
    }, STACK_STYLE.MILLI_SECONDS);
  }
}
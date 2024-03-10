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
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import buffer from '@ohos.buffer';
import { BusinessError } from '@ohos.base';
import Logger from './Logger';

let uri: string = '';
// Obtaining the Application File Path

let message: string = '';

/**
 * saveToUser.
 * Save content to user directory file
 * @param content Contents saved to a user directory file
 */
export async function saveToUser(content: string) {
  try {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['test.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    documentPicker.save(DocumentSaveOptions).then((DocumentSaveResult: Array<string>) => {
      Logger.info('DocumentViewPicker.save successfully, uri: ' + JSON.stringify(DocumentSaveResult));
      uri = DocumentSaveResult[0];
      let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      // Open a file stream based on the file path.
      fs.writeSync(file.fd, content);
    }).catch((err: BusinessError) => {
      Logger.error('DocumentViewPicker.save failed with err: ' + JSON.stringify(err));
    });
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    Logger.error('DocumentViewPicker failed with err: ' + err.message);
  }
}

/**
 * readUserFile.
 * Reads the contents of a user directory file.
 * @return Promise<string>.
 */
export async function readUserFile(): Promise<string> {
  try {
    let DocumentSelectOptions = new picker.DocumentSelectOptions();
    let documentPicker = new picker.DocumentViewPicker();
    await documentPicker.select(DocumentSelectOptions).then((DocumentSelectResult: Array<string>) => {
      Logger.info('DocumentViewPicker.select successfully, uri: ' + JSON.stringify(DocumentSelectResult));
      uri = DocumentSelectResult[0];
      let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      let stat = fs.statSync(file.fd);
      let size = stat.size;
      let buf = new ArrayBuffer(size);
      fs.readSync(file.fd, buf);
      let con = buffer.from(buf, 0);
      message = con.toString();
      Logger.info('DocumentViewPicker.select successfully, message: ' + message);
      return message;
    }).catch((err: BusinessError) => {
      Logger.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
    });
  } catch (error) {
    let err = error as BusinessError;
    Logger.error('DocumentViewPicker.select failed with err: ' + err.message);
  }
  return message;
}
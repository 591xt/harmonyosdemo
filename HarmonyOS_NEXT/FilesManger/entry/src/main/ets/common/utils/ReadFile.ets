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
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import buffer from '@ohos.buffer';

// Obtaining the Application File Path
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;
let res: string = '';

/**
 * readFile.
 * Reads the contents of a file and returns a string.
 * @return string.
 */
export function readFile(): string {
  let filePath = filesDir + '/test.txt';
  let stat = fs.statSync(filePath);
  let size = stat.size;
  let buf = new ArrayBuffer(size);
  // Open a file stream based on the file path.
  let fileStream = fs.createStreamSync(filePath, "r+");
  // File stream reading information
  fileStream.readSync(buf);
  // Converts the read information to the string type and returns the string type.
  let con = buffer.from(buf, 0);
  res = con.toString();
  fileStream.close()
  return res;
}

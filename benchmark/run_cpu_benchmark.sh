#!/bin/bash
# Copyright (C) 2020 THL A29 Limited, a Tencent company.
# All rights reserved.
# Licensed under the BSD 3-Clause License (the "License"); you may
# not use this file except in compliance with the License. You may
# obtain a copy of the License at
# https://opensource.org/licenses/BSD-3-Clause
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.
# See the AUTHORS file for names of contributors.

set -e
NUM_THREADS=(4 8)
FRAMEWORKS=("torch" "torch_jit" "turbo-transformers" "onnxruntime-cpu")
SEQ_LEN=(10 20 40 60 80 100 120 200 300 400 500)
BATCH_SIZE=(1 2)
N=150
MODEL="bert"
for n_th in ${NUM_THREADS[*]}
do
  for batch_size in ${BATCH_SIZE[*]}
  do
    for seq_len in ${SEQ_LEN[*]}
    do
      for framework in ${FRAMEWORKS[*]}
      do
        env OMP_WAIT_POLICY=ACTIVE OMP_NUM_THREADS=${n_th} python cpu_benchmark.py ${MODEL} --seq_len=${seq_len} --batch_size=${batch_size}\
            -n ${N} --framework=${framework} --num_threads=${n_th}
      done
    done
  done
done

ARG BUILD_IMAGE="python:3.10.2-bullseye"
ARG RUNTIME_IMAGE="python:3.10.2-alpine"

FROM ${BUILD_IMAGE} AS build
COPY . /app
WORKDIR /app
RUN mkdir -p ~/.pip && echo "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple\n[install]\ntrusted-host = https://pypi.tuna.tsinghua.edu.cn" > ~/.pip/pip.conf ; \
    python3 -m venv /venv && /venv/bin/pip install --upgrade pip && /venv/bin/pip install -r requirements.txt && chmod +x main.py

FROM ${RUNTIME_IMAGE}
COPY --from=build /app /app
COPY --from=build /venv /venv
WORKDIR /app
ENTRYPOINT [ "/venv/bin/python", "main.py" ]
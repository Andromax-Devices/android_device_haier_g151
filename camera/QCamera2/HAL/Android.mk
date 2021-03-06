LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_CLANG_CFLAGS += \
        -Wno-error=unused-private-field \
        -Wno-error=strlcpy-strlcat-size \
        -Wno-error=gnu-designator \
        -Wno-error=unused-variable \
        -Wno-error=format \
        -Wno-error=unused-parameter

LOCAL_SRC_FILES := \
    QCamera2Factory.cpp \
    QCamera2Hal.cpp \
    QCamera2HWI.cpp \
    QCameraMem.cpp \
    ../util/QCameraQueue.cpp \
    ../util/QCameraCmdThread.cpp \
    QCameraStateMachine.cpp \
    QCameraChannel.cpp \
    QCameraStream.cpp \
    QCameraPostProc.cpp \
    QCamera2HWICallbacks.cpp \
    QCameraParameters.cpp \
    QCameraThermalAdapter.cpp \
    wrapper/QualcommCamera.cpp

LOCAL_CFLAGS = -Wall -Wextra -Werror
LOCAL_CFLAGS += -DDEFAULT_ZSL_MODE_ON

#use media extension
#ifeq ($(TARGET_USES_MEDIA_EXTENSIONS), true)
LOCAL_CFLAGS += -DUSE_MEDIA_EXTENSIONS
LOCAL_CFLAGS += -Wno-unused-variable -Wno-unused-parameter -Wno-implicit-fallthrough
#endif

#Debug logs are enabled
#LOCAL_CFLAGS += -DDISABLE_DEBUG_LOG

ifeq ($(TARGET_USES_AOSP),true)
LOCAL_CFLAGS += -DVANILLA_HAL
endif

LOCAL_CFLAGS += -DDEFAULT_DENOISE_MODE_ON

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../stack/common \
        frameworks/native/include \
        frameworks/native/include/media/openmax \
        frameworks/native/libs/nativebase/include \
        frameworks/native/libs/nativewindow/include \
        $(call project-path-for,qcom-display)/libgralloc \
        $(call project-path-for,qcom-display)/libqdutils \
        $(call project-path-for,qcom-media)/libstagefrighthw \
        system/media/camera/include \
        $(LOCAL_PATH)/../../mm-image-codec/qexif \
        $(LOCAL_PATH)/../../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/../util \
        $(LOCAL_PATH)/wrapper \
        system/media/camera/include

ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_CFLAGS += -DTARGET_TS_MAKEUP
LOCAL_C_INCLUDES += $(LOCAL_PATH)/tsMakeuplib/include
endif

LOCAL_HEADER_LIBRARIES := generated_kernel_headers
LOCAL_SHARED_LIBRARIES := libcamera_client liblog libhardware libutils libcutils libdl liblog libsensor
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface libqdMetaData libnativewindow
LOCAL_SHARED_LIBRARIES += libhidltransport libsensor android.hidl.token@1.0-utils android.hardware.graphics.bufferqueue@1.0
LOCAL_STATIC_LIBRARIES := libarect
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_SHARED_LIBRARIES += libts_face_beautify_hal libts_detected_face_hal
endif
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_32_BIT_ONLY := true
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

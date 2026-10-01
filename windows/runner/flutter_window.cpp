#include "flutter_window.h"

#include <optional>
#include <algorithm>
#include "resource.h"

namespace {
LRESULT CALLBACK SplashProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  if (message == WM_PAINT) {
    PAINTSTRUCT ps;
    HDC dc = BeginPaint(hwnd, &ps);
    RECT rect;
    GetClientRect(hwnd, &rect);
    FillRect(dc, &rect, static_cast<HBRUSH>(GetStockObject(WHITE_BRUSH)));
    HBITMAP bitmap = LoadBitmap(GetModuleHandle(nullptr), MAKEINTRESOURCE(IDB_SPLASH));
    if (bitmap) {
      BITMAP info;
      GetObject(bitmap, sizeof(info), &info);
      HDC source = CreateCompatibleDC(dc);
      HGDIOBJ previous = SelectObject(source, bitmap);
      const int size = std::min({MulDiv(280, GetDpiForWindow(hwnd), 96),
                                 static_cast<int>(rect.right), static_cast<int>(rect.bottom)});
      SetStretchBltMode(dc, HALFTONE);
      SetBrushOrgEx(dc, 0, 0, nullptr);
      StretchBlt(dc, (rect.right - size) / 2, (rect.bottom - size) / 2, size, size,
                 source, 0, 0, info.bmWidth, info.bmHeight, SRCCOPY);
      SelectObject(source, previous);
      DeleteDC(source);
      DeleteObject(bitmap);
    }
    EndPaint(hwnd, &ps);
    return 0;
  }
  return DefWindowProc(hwnd, message, wparam, lparam);
}
}  // namespace


#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  WNDCLASS splash_class{};
  splash_class.lpfnWndProc = SplashProc;
  splash_class.hInstance = GetModuleHandle(nullptr);
  splash_class.lpszClassName = L"HavenaSplash";
  splash_class.hbrBackground = static_cast<HBRUSH>(GetStockObject(WHITE_BRUSH));
  RegisterClass(&splash_class);
  splash_window_ = CreateWindow(L"HavenaSplash", L"", WS_CHILD | WS_VISIBLE,
      0, 0, frame.right, frame.bottom, GetHandle(), nullptr, GetModuleHandle(nullptr), nullptr);
  Show();
  UpdateWindow(splash_window_);

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  SetWindowPos(splash_window_, HWND_TOP, 0, 0, frame.right, frame.bottom, SWP_NOACTIVATE);

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    DestroyWindow(splash_window_);
    splash_window_ = nullptr;
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (splash_window_) {
    DestroyWindow(splash_window_);
    splash_window_ = nullptr;
  }
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (message == WM_SIZE && splash_window_) {
    MoveWindow(splash_window_, 0, 0, LOWORD(lparam), HIWORD(lparam), TRUE);
    InvalidateRect(splash_window_, nullptr, TRUE);
  }
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

bundle_name="ABC Modified Modifiers.bundle"
keyboard_layouts_dir="/Library/Keyboard Layouts"

if [[ ! -d "${keyboard_layouts_dir}/${bundle_name}" ]]; then
  sudo cp -R "${CHEZMOI_SOURCE_DIR}/ignored/${bundle_name}" "${keyboard_layouts_dir}"
fi

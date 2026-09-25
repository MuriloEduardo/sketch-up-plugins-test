# frozen_string_literal: true

require 'test_helper'
require_source 'me_vray_toolkit/vray/render_output'

class RenderOutputTest < Minitest::Test

  RenderOutput = MuriloEduardo::VRayToolkit::VRayBridge::RenderOutput
  TIME = Time.new(2026, 9, 25, 3, 50, 7)

  def test_renders_go_next_to_the_saved_model
    path = RenderOutput.path(model_path: 'C:/proj/Casa.skp', scene: 'P.Planta', time: TIME, temp_dir: 'T:')

    assert_equal('C:/proj/Casa renders/P.Planta 2026-09-25 035007.png', path)
  end

  def test_windows_backslashes_are_normalized
    path = RenderOutput.path(model_path: 'C:\\proj\\Casa.skp', scene: 'P', time: TIME, temp_dir: 'T:')

    assert_equal('C:/proj/Casa renders/P 2026-09-25 035007.png', path)
  end

  def test_unsaved_model_uses_the_temp_folder_and_view_name
    path = RenderOutput.path(model_path: '', scene: nil, time: TIME, temp_dir: 'T:/tmp')

    assert_equal('T:/tmp/V-Ray Toolkit renders/view 2026-09-25 035007.png', path)
  end

  def test_scene_names_are_made_safe_for_files
    assert_equal('Sala_ 1_2', RenderOutput.safe_name('Sala: 1/2'))
    assert_equal('view', RenderOutput.safe_name(' .. '))
    assert_equal(RenderOutput::MAX_NAME, RenderOutput.safe_name('x' * 200).size)
  end

end

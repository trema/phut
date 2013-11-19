# -*- coding: utf-8 -*-

# Base module.
module Phuture
  def self.setting
    {
      'PID_DIR' => Phuture::ROOT,
      'LOG_DIR' => Phuture::ROOT,
      'SOCKET_DIR' => Phuture::ROOT,
    }
  end
end

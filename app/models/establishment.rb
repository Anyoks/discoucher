class Establishment < ApplicationRecord
	has_attached_file :logo, styles: { small: "64x64", med: "100x100", large: "200x200" }
end

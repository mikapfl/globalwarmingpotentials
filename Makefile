all: src/globalwarmingpotentials/__init__.py index.js

src/globalwarmingpotentials/__init__.py index.ts: scripts/generate_modules.py globalwarmingpotentials.csv venv
	@./venv/bin/python $<
	@./venv/bin/black src/globalwarmingpotentials/*.py

index.js: index.ts tsconfig.json package.json
	@npm install
	@npm run build
	@npm run format

venv: scripts/requirements.txt
	[ -d ./venv ] || python3 -m venv venv
	./venv/bin/pip install --upgrade pip
	./venv/bin/pip install -Ur $<
	touch venv

clean-generated-files:
	rm -rf index.js index.ts py/globalwarmingpotentials/__init__.py

clean-venv:
	rm -rf venv

clean: clean-generated-files clean-venv

tag:
	./scripts/create_tag.sh

.PHONY: clean clean-generated-files clean-venv tag publish-on-pypi publish-on-test-pypi test-pypi-install

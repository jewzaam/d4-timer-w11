.PHONY: default install install-dev install-no-deps uninstall clean format lint typecheck test test-verbose coverage run run-debug

PYTHON := python3

default: format lint typecheck test coverage

install:
	$(PYTHON) -m pip install .

install-dev:
	$(PYTHON) -m pip install -e ".[dev]"

install-no-deps:
	$(PYTHON) -m pip install -e . --no-deps

uninstall:
	$(PYTHON) -m pip uninstall -y d4-timer

clean:
	rm -rf build/ dist/ *.egg-info
	find . -type d -name __pycache__ -exec rm -r {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	rm -rf .pytest_cache .mypy_cache .coverage htmlcov

format: install-dev
	$(PYTHON) -m black d4_timer/ tests/

lint: install-dev
	$(PYTHON) -m flake8 d4_timer/ tests/

typecheck: install-dev
	$(PYTHON) -m mypy d4_timer/

test: install-dev
	$(PYTHON) -m pytest

test-verbose: install-dev
	$(PYTHON) -m pytest -v

coverage: install-dev
	$(PYTHON) -m pytest --cov=d4_timer --cov-report=term-missing

run:
	$(PYTHON) -m d4_timer

run-debug:
	$(PYTHON) -m d4_timer --debug

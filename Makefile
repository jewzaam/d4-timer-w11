.PHONY: install-dev test coverage lint format typecheck clean run

install-dev:
	python3 -m pip install -e ".[dev]"

test:
	python3 -m pytest tests/

coverage:
	python3 -m pytest --cov=d4_timer --cov-config=pyproject.toml --cov-report=term-missing tests/

lint:
	python3 -m flake8 d4_timer/ tests/

format:
	python3 -m black d4_timer/ tests/

typecheck:
	python3 -m mypy d4_timer/

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null; \
	find . -name "*.pyc" -delete 2>/dev/null; \
	rm -rf .pytest_cache .mypy_cache .coverage htmlcov dist build *.egg-info

run:
	python3 -m d4_timer

run-debug:
	python3 -m d4_timer --debug

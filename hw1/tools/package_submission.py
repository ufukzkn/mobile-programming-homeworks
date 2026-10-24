"""Build a source archive with an explicit allowlist; no build/cache files."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parents[1]
out = root / 'output/submission/campus_event_explorer.zip'
out.parent.mkdir(parents=True, exist_ok=True)
files = ['README.md', 'pubspec.yaml', 'pubspec.lock', 'analysis_options.yaml', '.gitignore', '.metadata']
folders = ['lib', 'assets', 'test', 'docs', 'tools', 'web', 'android', '.vscode']
excluded = {'build', '.dart_tool', '.gradle', '.kotlin', '.cxx', 'captures', '__pycache__'}
with ZipFile(out, 'w', ZIP_DEFLATED) as z:
    for name in files:
        z.write(root/name, 'campus_event_explorer/'+name)
    for folder in folders:
        for path in sorted((root/folder).rglob('*')):
            rel = path.relative_to(root)
            if not path.is_file() or any(p in excluded for p in rel.parts):
                continue
            if path.name in {'local.properties', 'key.properties'} or path.suffix in {'.iml', '.jks', '.keystore'}:
                continue
            z.write(path, 'campus_event_explorer/'+rel.as_posix())
print(out)
with ZipFile(out) as z:
    assert not any('/build/' in p or '/.dart_tool/' in p or 'local.properties' in p for p in z.namelist())
    print(f'{len(z.namelist())} source/evidence files, {out.stat().st_size:,} bytes')

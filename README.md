# Power the Polls ActionKit Templates
Power the Polls ActionKit Templates is the source repository for the Django-style templates that render Power the Polls pages hosted in ActionKit.

## Why this project exists
Power the Polls uses ActionKit to publish supporter-facing pages such as sign-up forms, petitions, donation pages, event pages, account pages, and transactional emails. ActionKit stores and renders these pages from templatesets.

This repository exists so those templates can be reviewed, versioned, and tested locally before they are used in ActionKit. It helps developers and campaign staff make safer changes to public pages that support poll worker recruitment and related voter participation work.

In the broader Power the Polls ecosystem, this repository controls the page layer for ActionKit-hosted experiences. It does not contain the full Power the Polls website, backend services, or ActionKit data. It contains the templates ActionKit uses to render pages and forms.

## Features and key capabilities
- Provides ActionKit templates for common page types, including sign-up, petition, donation, letter, call, survey, event, account, login, and unsubscribe pages.
- Defines shared page structure in `wrapper.html`, including metadata, analytics tags, base assets, and the main content container.
- Defines shared styling in `ptp_styles.html`.
- Includes shared form partials such as `user_form.html`, `user_form_wrapper.html`, `country_select.html`, `state_select.html`, and `progress_meter.html`.
- Includes event workflow templates for hosts, attendees, moderators, rosters, emails, and tell-a-friend messages.
- Can be previewed locally with the `aktemplates` development server from MoveOn's `actionkit-templates` package.

## Prerequisites
Install the following before working on this repository:

- Git.
- Python 3.7.6. The required version is recorded in `.python-version`.
- `pip` for Python 3.7.
- Optional but recommended: `pyenv` or another Python version manager.

The repository depends on older ActionKit-compatible packages:

- `Django==1.8`
- `requests==2.22.0`
- `actionkit_templates` from `MoveOnOrg/actionkit-templates`

Use a virtual environment. These dependency versions are intentionally old to match ActionKit template rendering behavior and should not be installed globally.

## Local setup
### 1. Clone the repository
```bash
git clone https://github.com/PowerThePolls/ptp-actionkit.git
cd ptp-actionkit
```

### 2. Install Python 3.7.6
If you use `pyenv`:

```bash
pyenv install 3.7.6
pyenv local 3.7.6
python --version
```

Expected output:

```text
Python 3.7.6
```

### 3. Create and activate a virtual environment
```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
```

Your shell prompt should now show that `.venv` is active.

### 4. Install dependencies
```bash
pip install -r requirements.txt
```

This installs the `aktemplates` command used to preview ActionKit templates locally.

If installation fails because the `git://` dependency URL is blocked by your network or GitHub client, install the ActionKit template package with HTTPS and then retry the requirements install:

```bash
pip install -e git+https://github.com/MoveOnOrg/actionkit-templates.git@eeea69f37c7b5e1c424e2cd4d36a6d15a9902e20#egg=actionkit_templates
pip install -r requirements.txt
```

### 5. Run the local template server
```bash
aktemplates runserver
```

By default, the server uses Django's local development server. Open:

```text
http://127.0.0.1:8000/
```

To use a different host or port:

```bash
aktemplates runserver 0.0.0.0:1234
```

Stop the server with `Ctrl+C`.

## Environment variables
This repository does not require a `.env` file for local development.

The `aktemplates` runner supports optional environment variables when you need custom preview behavior:

```bash
TEMPLATE_DIR=. aktemplates runserver
```

| Variable | Required | Description |
| --- | --- | --- |
| `TEMPLATE_DIR` | No | Directory where `aktemplates` looks for templates. The current repository root works for this project. |
| `CUSTOM_CONTEXTS` | No | Path to a JSON file containing custom preview contexts for specific templates. Useful when a template needs page, form, event, or user data that is not present in the default preview context. |
| `STATIC_ROOT` | No | Directory served by the local preview server at `/static/`. Useful if you add local static assets. |
| `STATIC_FALLBACK` | No | Directory used as a fallback for externally loaded JavaScript or CSS files while developing offline. |

Example custom context file:

```json
{
  "signup_example": {
    "filename": "signup.html",
    "page": {
      "title": "Example sign-up page",
      "name": "example_signup",
      "type": "Signup"
    },
    "form": {
      "introduction_text": "Use this context to preview a sign-up page locally."
    }
  }
}
```

Run with the custom context:

```bash
CUSTOM_CONTEXTS=contexts.json aktemplates runserver
```

Do not commit local context files if they contain real supporter data, credentials, or private campaign information.

## Repository structure
Most files in this repository are ActionKit templates stored at the repository root.

Important files:

- `wrapper.html`: Shared layout for public pages. This includes metadata, analytics scripts, base assets, branding, and the `{% block content %}` area used by page templates.
- `ptp_styles.html`: Shared CSS for the Power the Polls ActionKit templates.
- `signup.html`, `petition.html`, `donate.html`, `letter.html`, `call.html`, `survey.html`: Core action page templates.
- `user_form.html`, `user_form_wrapper.html`, `user_form_intl.html`: Shared supporter form templates.
- `event_*.html` and `event_*.txt`: Event page, event management, event email, and tell-a-friend templates.
- `thanks.html`: Post-action confirmation page.
- `requirements.txt`: Python dependencies for local preview.
- `.python-version`: Expected Python version.

The `src/` directory is ignored by Git and may be created by editable Python package installs. Do not put project source templates there.

## Usage examples
Preview the default template set:

```bash
source .venv/bin/activate
aktemplates runserver
```

Preview on a custom port:

```bash
source .venv/bin/activate
aktemplates runserver 127.0.0.1:9000
```

Check which templates changed before opening a pull request:

```bash
git status
git diff --stat
git diff
```

Search for templates that include the shared user form:

```bash
grep -R "user_form_wrapper" .
```

## How to make changes
1. Create a branch from `master`.

   ```bash
   git checkout master
   git pull origin master
   git checkout -b your-branch-name
   ```

2. Make the smallest template change that solves the issue.

3. Run the local preview server.

   ```bash
   source .venv/bin/activate
   aktemplates runserver
   ```

4. Open the affected page template in the local preview server and check:
   - The page renders without a Django template error.
   - Forms still include required hidden fields such as `page`.
   - Shared partials still load correctly.
   - Mobile and desktop layouts are usable.
   - Analytics, external assets, and links are still intentional.

5. Review your diff.

   ```bash
   git diff
   ```

6. Commit and open a pull request.

   ```bash
   git add README.md path/to/changed-template.html
   git commit -m "Describe the template change"
   git push origin your-branch-name
   ```

## Testing and validation
There is no automated test suite in this repository today.

Before requesting review, validate changes manually:

- Run `aktemplates runserver`.
- Load each changed template locally.
- Check the terminal for Django template errors.
- Test the changed flow in a browser, including form display and client-side behavior.
- Inspect responsive behavior at mobile and desktop widths.
- Confirm no private data, API keys, supporter records, or credentials were added.

For changes that affect live ActionKit behavior, also test in ActionKit preview or a non-production templateset before applying the change to a live page.

## Deployment and GitHub Actions
This repository does not currently include GitHub Actions workflows. Pushing to GitHub does not automatically deploy templates from this repository by itself.

Template changes move toward production through the review and ActionKit templateset process:

1. Open a pull request against `master`.
2. Request review from the responsible Power the Polls maintainer.
3. After approval, merge the pull request.
4. Apply the changed templates to the appropriate ActionKit templateset.
5. Preview the templateset in ActionKit.
6. Assign the templateset to the intended ActionKit page or make it active for the relevant pages.
7. Verify the live page after publishing.

ActionKit may be configured separately to connect a templateset to a GitHub repository. If that integration is enabled for this project, use the ActionKit templateset interface to pull or save the reviewed changes from GitHub. If it is not enabled, copy the changed template content into the matching template in ActionKit.

Important deployment note: saving a template in a templateset used by a live ActionKit page can affect that page immediately. Preview first and coordinate timing for high-traffic or campaign-critical pages.

## Reporting issues
Use GitHub Issues or a pull request comment to report bugs or request changes.

Include:

- The affected template name.
- The ActionKit page type or URL, if available.
- Steps to reproduce.
- Expected behavior.
- Actual behavior.
- Screenshots for visual bugs.
- Browser and device details for responsive or JavaScript issues.

## Contributing guidelines
- Keep changes focused. Avoid mixing unrelated template, style, and content changes.
- Prefer shared partials when the same behavior is needed across multiple templates.
- Preserve ActionKit template tags and required form fields unless the change explicitly requires updating them.
- Do not commit real supporter data, private campaign data, API keys, credentials, or exported ActionKit records.
- Use clear pull request descriptions that explain the user-facing impact and the validation performed.
- Ask for review before applying changes to a live ActionKit templateset.

## Common setup issues
### `aktemplates: command not found`
The Python dependencies are not installed or the virtual environment is not active.

```bash
source .venv/bin/activate
pip install -r requirements.txt
which aktemplates
```

### Django or dependency installation fails
Confirm you are using Python 3.7.6. Newer Python versions may not work with Django 1.8.

```bash
python --version
```

### The editable ActionKit dependency does not install
Some environments block the old `git://` protocol. Use the HTTPS install command from the local setup section.

### A template renders locally but behaves differently in ActionKit
The local server uses preview contexts and does not contain production ActionKit data. Validate high-risk changes in ActionKit preview before publishing.

## License
No license file is currently included in this repository. Confirm licensing with the Power the Polls maintainers before reusing these templates outside this project.

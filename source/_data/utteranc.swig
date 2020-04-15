{% if theme.utteranc.enable %}
    <script src="https://utteranc.es/client.js"
            repo="{{ theme.utteranc.repo }}"
            issue-term="{{ theme.utteranc.issue-term }}"
            label="{{ theme.utteranc.label }}"
            theme="{{ theme.utteranc.theme }}"
            crossorigin="anonymous"
            async>
    </script>
{% endif %}
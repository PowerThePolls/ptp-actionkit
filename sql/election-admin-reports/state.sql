Power the Polls Election Admin Report (State)

SELECT
    u.first_name,
    u.last_name,
    u.email,
    (
        SELECT
            COALESCE(GROUP_CONCAT(phone ORDER BY core_phone.id DESC SEPARATOR ', '), '')
        FROM
            core_phone
        WHERE
            core_phone.user_id = u.id
    ) AS phone,
    u.city,
    uf.value AS county,
    u.state,
    u.zip,
    COALESCE((
        SELECT
            COALESCE(GROUP_CONCAT(DISTINCT TRIM(value) ORDER BY value SEPARATOR ', '), '')
        FROM
            core_action a
        JOIN core_actionfield af ON a.id = af.parent_id
        WHERE
            af.name = 'language'
            AND a.user_id = u.id
    ), '') AS languages,
    COALESCE((
        SELECT
            MAX(DISTINCT uf.value)
        FROM core_userfield uf
        WHERE
            uf.name = 'tech_skills'
            AND uf.parent_id = u.id
    ), '') AS tech_skills,
    CAST((
        SELECT
            MAX(created_at)
        FROM core_action
        WHERE
            user_id = u.id
            AND (page_id = 12 OR page_id = 171)
    ) AS DATE) AS signup_date
FROM
    core_user AS u
    JOIN core_userfield uf ON u.id = uf.parent_id
WHERE
    LOWER(u.state) = LOWER({state})
    AND uf.name = 'county'
    AND NOT EXISTS (
        SELECT
            1
        FROM
            core_action
        JOIN core_page_tags USING (page_id)
        WHERE
            core_action.user_id = u.id
            AND core_page_tags.tag_id IN(137)
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM
            core_user_groups
        WHERE
            core_user_groups.user_id = u.id
            AND core_user_groups.usergroup_id = 22
    )
ORDER BY
    signup_date DESC;
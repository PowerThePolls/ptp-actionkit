Power the Polls Election Admin Report (City)
-- ActionKit report: https://ptp.actionkit.com/admin/reports/queryreport/2471/change/

SELECT
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COALESCE(GROUP_CONCAT(phone ORDER BY core_phone.id DESC SEPARATOR ', '), '')
     FROM core_phone
     WHERE core_phone.user_id = u.id) AS phone,
    u.city,
    uf.value AS county,
    u.state,
    u.zip,
    COALESCE((SELECT MAX(DISTINCT uf.value)
              FROM core_userfield uf
              WHERE uf.name = 'tech_skills'
                AND uf.parent_id = u.id), '') AS tech_skills,
    COALESCE((SELECT MAX(DISTINCT uf.value)
              FROM core_userfield uf
              WHERE uf.name = 'first_time_poll_worker'
                AND uf.parent_id = u.id), '') AS first_time_poll_worker,
    COALESCE((SELECT MAX(DISTINCT uf.value)
              FROM core_userfield uf
              WHERE uf.name = 'prior_experience_being_poll_worker'
                AND uf.parent_id = u.id), '') AS prior_experience_being_poll_worker,
    COALESCE((SELECT MAX(DISTINCT uf.value)
              FROM core_userfield uf
              WHERE uf.name = 'fluent_second_language'
                AND uf.parent_id = u.id), '') AS fluent_second_language,
    CAST((SELECT MAX(created_at)
          FROM core_action
          WHERE user_id = u.id
            AND page_id = 12) AS DATE) AS signup_date
FROM 
    core_user AS u
JOIN 
    core_userfield uf ON u.id = uf.parent_id
WHERE 
    uf.name = 'county' 
    AND LOWER(u.state) = LOWER({state})
    AND LOWER(u.city) = LOWER({city})
    AND EXISTS (
        SELECT 1
        FROM core_action
        WHERE user_id = u.id
            AND page_id = 12
            AND created_at >= '2025-01-01'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM core_action
        JOIN core_page_tags USING (page_id)
        WHERE core_action.user_id = u.id
          AND core_page_tags.tag_id IN (137)
    )
    AND NOT EXISTS (
        SELECT 1 
        FROM core_user_groups
        WHERE core_user_groups.user_id = u.id
          AND core_user_groups.usergroup_id = 22
    )
ORDER BY 
    signup_date DESC;
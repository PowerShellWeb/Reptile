describe Reptile {
    context 'Is a mostly safe repl' {
        it 'Runs things in restricted language' {
            $r = Reptile

            Invoke-RestMethod -Uri $r.Url -Body "1+1" -Method Post |
                Should -Be 2

            $r.HttpListener.Stop()

            $r | Remove-Job -Force
        }

        it 'Will not run unapproved commands' {
            $r = Reptile

            Invoke-RestMethod -Uri $r.Url -Body "Stop-Process -id $pid" -Method Post |
                Should -Match "line:\d"

            $r.HttpListener.Stop()

            $r | Remove-Job -Force
        }
    }
}